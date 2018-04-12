describe 'POST /api/v1/driving_schools/:driving_school_id/driving_lessons' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let(:driving_school) do
    create(:driving_school, :with_schedule_settings, status: :active)
  end

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           is_owner: is_owner,
           can_modify_schedules: can_modify_schedules,
           status: :active)
  end

  let(:is_owner) { false }
  let(:can_modify_schedules) { false }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end

  let!(:slot_1) do
    create(:slot,
           employee_driving_school: employee_driving_school,
           start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
  end

  let!(:slot_2) do
    create(:slot,
           employee_driving_school: employee_driving_school,
           start_time: DateTime.new(2050, 2, 3, 12, 0, 0))
  end

  let!(:slot_3) do
    create(:slot,
           employee_driving_school: employee_driving_school,
           start_time: DateTime.new(2050, 2, 3, 13, 0, 0))
  end

  let(:params) do
    {
      employee_id: employee.id,
      student_id: student.id,
      slot_ids: [slot_1.id, slot_2.id, slot_3.id]
    }
  end

  let(:response_keys) { %w[employee student slots id start_time status] }

  before do
    post "/api/v1/driving_schools/#{driving_school.id}/driving_lessons",
         headers: current_user.create_new_auth_token,
         params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when current_user is owner od driving school' do
      let(:is_owner) { true }

      context 'when params VALID' do
        it 'returns 201 http status code' do
          expect(response.status).to eq 201
        end

        it 'creates DrivingLesson record' do
          expect(DrivingLesson.count).to eq 1
        end

        it 'creates Activity record' do
          expect(Activity.count).to eq 1
        end

        it 'created DrivingLesson record has proper attributes' do
          expect(DrivingLesson.last.attributes).to include(
            'start_time' => slot_2.start_time,
            'driving_school_id' => driving_school.id,
            'employee_id' => employee.id,
            'status' => 'active',
            'student_id' => student.id
          )
        end

        it 'assigns Slots to driving lesson' do
          expect(DrivingLesson.last.slots.pluck(:id)).to match_array(
            [slot_1.id, slot_2.id, slot_3.id]
          )
        end

        it 'creates proper Activity record' do
          expect(Activity.last.attributes).to include(
            'target_id' => DrivingLesson.last.id,
            'target_type' => 'DrivingLesson',
            'activity_type' => 'driving_lesson_scheduled',
            'user_id' => current_user.id,
            'driving_school_id' => driving_school.id,
          )
        end

        context 'response body contains proper' do
          subject { json_response }

          it 'keys' do
            expect(subject.keys).to match_array response_keys
          end

          it 'attributes' do
            expect(subject).to include(
              'start_time' => slot_2.start_time,
              'employee' => {
                'id' => employee.id,
                'name' => employee.name,
                'surname' => employee.surname
              },
              'student' => {
                'id' => student.id,
                'name' => student.name,
                'surname' => student.surname
              }
            )
          end

          it 'slots attributes' do
            expect(subject['slots']).to match_array([
              {
                'id' => slot_1.id,
                'start_time' => slot_1.start_time,
                'driving_lesson_id' => DrivingLesson.last.id,
                'release_at' => slot_1.release_at,
                'locking_user_id' => slot_1.locking_user_id,
                'employee_id' => employee.id,
                'driving_school_id' => driving_school.id
              },
              {
                'id' => slot_2.id,
                'start_time' => slot_2.start_time,
                'driving_lesson_id' => DrivingLesson.last.id,
                'release_at' => slot_2.release_at,
                'locking_user_id' => slot_2.locking_user_id,
                'employee_id' => employee.id,
                'driving_school_id' => driving_school.id
              },
              {
                'id' => slot_3.id,
                'start_time' => slot_3.start_time,
                'driving_lesson_id' => DrivingLesson.last.id,
                'release_at' => slot_3.release_at,
                'locking_user_id' => slot_3.locking_user_id,
                'employee_id' => employee.id,
                'driving_school_id' => driving_school.id
              }
            ])
          end
        end
      end

      context 'when params INVALID' do
        context 'when slots are empty' do
          let(:params) do
            {
              employee_id: employee.id,
              student_id: student.id,
              slot_ids: []
            }
          end

          it 'returns 404 http status code' do
            expect(response.status).to eq 404
          end
        end

        context 'when slots are already booked' do
          let!(:slot_1) do
            create(:slot,
                   :booked,
                   employee_driving_school: employee_driving_school,
                   start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
          end

          it 'returns 404 http status code' do
            expect(response.status).to eq 404
          end
        end

        context 'when slots are NOT half an hour aparat' do
          let!(:slot_1) do
            create(:slot,
                   employee_driving_school: employee_driving_school,
                   start_time: DateTime.new(2050, 2, 3, 10, 30, 0))
          end

          it 'returns 400 http status code' do
            expect(response.status).to eq 400
          end

          it 'returns proper error message' do
            expect(json_response['error']).to eq 'Slots must be half an hour apart'
          end
        end
      end
    end

    context 'when current_user can modify schedules' do
      let(:can_modify_schedules) { true }

      context 'when params VALID' do
        it 'returns 201 http status code' do
          expect(response.status).to eq 201
        end

        it 'creates DrivingLesson record' do
          expect(DrivingLesson.count).to eq 1
        end

        it 'creates Activity record' do
          expect(Activity.count).to eq 1
        end

        it 'created DrivingLesson record has proper attributes' do
          expect(DrivingLesson.last.attributes).to include(
            'start_time' => slot_2.start_time,
            'driving_school_id' => driving_school.id,
            'employee_id' => employee.id,
            'status' => 'active',
            'student_id' => student.id
          )
        end

        it 'assigns Slots to driving lesson' do
          expect(DrivingLesson.last.slots.pluck(:id)).to match_array(
            [slot_1.id, slot_2.id, slot_3.id]
          )
        end

        it 'creates proper Activity record' do
          expect(Activity.last.attributes).to include(
            'target_id' => DrivingLesson.last.id,
            'target_type' => 'DrivingLesson',
            'activity_type' => 'driving_lesson_scheduled',
            'user_id' => current_user.id,
            'driving_school_id' => driving_school.id,
          )
        end

        context 'response body contains proper' do
          subject { json_response }

          it 'keys' do
            expect(subject.keys).to match_array response_keys
          end

          it 'attributes' do
            expect(subject).to include(
              'start_time' => slot_2.start_time,
              'employee' => {
                'id' => employee.id,
                'name' => employee.name,
                'surname' => employee.surname
              },
              'student' => {
                'id' => student.id,
                'name' => student.name,
                'surname' => student.surname
              }
            )
          end

          it 'slots attributes' do
            expect(subject['slots']).to match_array([
              {
                'id' => slot_1.id,
                'start_time' => slot_1.start_time,
                'driving_lesson_id' => DrivingLesson.last.id,
                'release_at' => slot_1.release_at,
                'locking_user_id' => slot_1.locking_user_id,
                'employee_id' => employee.id,
                'driving_school_id' => driving_school.id
              },
              {
                'id' => slot_2.id,
                'start_time' => slot_2.start_time,
                'driving_lesson_id' => DrivingLesson.last.id,
                'release_at' => slot_2.release_at,
                'locking_user_id' => slot_2.locking_user_id,
                'employee_id' => employee.id,
                'driving_school_id' => driving_school.id
              },
              {
                'id' => slot_3.id,
                'start_time' => slot_3.start_time,
                'driving_lesson_id' => DrivingLesson.last.id,
                'release_at' => slot_3.release_at,
                'locking_user_id' => slot_3.locking_user_id,
                'employee_id' => employee.id,
                'driving_school_id' => driving_school.id
              }
            ])
          end
        end
      end

      context 'when params INVALID' do
        context 'when slots are empty' do
          let(:params) do
            {
              employee_id: employee.id,
              student_id: student.id,
              slot_ids: []
            }
          end

          it 'returns 404 http status code' do
            expect(response.status).to eq 404
          end
        end

        context 'when slots are already booked' do
          let!(:slot_1) do
            create(:slot,
                   :booked,
                   employee_driving_school: employee_driving_school,
                   start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
          end

          it 'returns 404 http status code' do
            expect(response.status).to eq 404
          end
        end

        context 'when slots are NOT half an hour aparat' do
          let!(:slot_1) do
            create(:slot,
                   employee_driving_school: employee_driving_school,
                   start_time: DateTime.new(2050, 2, 3, 10, 30, 0))
          end

          it 'returns 400 http status code' do
            expect(response.status).to eq 400
          end

          it 'returns proper error message' do
            expect(json_response['error']).to eq 'Slots must be half an hour apart'
          end
        end
      end
    end

    context 'when current_user is regular' do
      it 'returns 401 http status code' do
        expect(response.status).to eq 401
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

    context 'when creates driving lesson for himself' do
      context 'when params VALID' do
        it 'returns 201 http status code' do
          expect(response.status).to eq 201
        end

        it 'creates DrivingLesson record' do
          expect(DrivingLesson.count).to eq 1
        end

        it 'creates Activity record' do
          expect(Activity.count).to eq 1
        end

        it 'created DrivingLesson record has proper attributes' do
          expect(DrivingLesson.last.attributes).to include(
            'start_time' => slot_2.start_time,
            'driving_school_id' => driving_school.id,
            'employee_id' => employee.id,
            'status' => 'active',
            'student_id' => student.id
          )
        end

        it 'assigns Slots to driving lesson' do
          expect(DrivingLesson.last.slots.pluck(:id)).to match_array(
            [slot_1.id, slot_2.id, slot_3.id]
          )
        end

        it 'creates proper Activity record' do
          expect(Activity.last.attributes).to include(
            'target_id' => DrivingLesson.last.id,
            'target_type' => 'DrivingLesson',
            'activity_type' => 'driving_lesson_scheduled',
            'user_id' => current_user.id,
            'driving_school_id' => driving_school.id,
          )
        end

        context 'response body contains proper' do
          subject { json_response }

          it 'keys' do
            expect(subject.keys).to match_array response_keys
          end

          it 'attributes' do
            expect(subject).to include(
              'start_time' => slot_2.start_time,
              'employee' => {
                'id' => employee.id,
                'name' => employee.name,
                'surname' => employee.surname
              },
              'student' => {
                'id' => student.id,
                'name' => student.name,
                'surname' => student.surname
              }
            )
          end

          it 'slots attributes' do
            expect(subject['slots']).to match_array([
              {
                'id' => slot_1.id,
                'start_time' => slot_1.start_time,
                'driving_lesson_id' => DrivingLesson.last.id,
                'release_at' => slot_1.release_at,
                'locking_user_id' => slot_1.locking_user_id,
                'employee_id' => employee.id,
                'driving_school_id' => driving_school.id
              },
              {
                'id' => slot_2.id,
                'start_time' => slot_2.start_time,
                'driving_lesson_id' => DrivingLesson.last.id,
                'release_at' => slot_2.release_at,
                'locking_user_id' => slot_2.locking_user_id,
                'employee_id' => employee.id,
                'driving_school_id' => driving_school.id
              },
              {
                'id' => slot_3.id,
                'start_time' => slot_3.start_time,
                'driving_lesson_id' => DrivingLesson.last.id,
                'release_at' => slot_3.release_at,
                'locking_user_id' => slot_3.locking_user_id,
                'employee_id' => employee.id,
                'driving_school_id' => driving_school.id
              }
            ])
          end
        end
      end

      context 'when params INVALID' do
        context 'when slots are empty' do
          let(:params) do
            {
              employee_id: employee.id,
              student_id: student.id,
              slot_ids: []
            }
          end

          it 'returns 404 http status code' do
            expect(response.status).to eq 404
          end
        end

        context 'when slots are already booked' do
          let!(:slot_1) do
            create(:slot,
                   :booked,
                   employee_driving_school: employee_driving_school,
                   start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
          end

          it 'returns 404 http status code' do
            expect(response.status).to eq 404
          end
        end

        context 'when slots are NOT half an hour aparat' do
          let!(:slot_1) do
            create(:slot,
                   employee_driving_school: employee_driving_school,
                   start_time: DateTime.new(2050, 2, 3, 10, 30, 0))
          end

          it 'returns 400 http status code' do
            expect(response.status).to eq 400
          end

          it 'returns proper error message' do
            expect(json_response['error']).to eq 'Slots must be half an hour apart'
          end
        end
      end
    end

    context 'when creates driving lesson for other student' do
      let(:other_student) { other_student_driving_school.student }
      let(:other_student_driving_school) do
        create(:student_driving_school,
               driving_school: driving_school,
               status: :active)
      end

      let(:params) do
        {
          employee_id: employee.id,
          student_id: other_student.id,
          slot_ids: [slot_1.id, slot_2.id, slot_3.id]
        }
      end

      it 'returns 401 http status code' do
        expect(response.status).to eq 401
      end
    end
  end
end
