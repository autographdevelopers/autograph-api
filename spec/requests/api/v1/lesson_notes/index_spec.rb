describe 'GET /api/v1/driving_schools/:driving_school_id/driving_lessons/:driving_lesson_id/lesson_notes' do
  let(:driving_school) { create(:driving_school, status: :active) }
  let(:employee) { create(:employee) }
  let!(:employee_driving_school) do
    create(:employee_driving_school,
      driving_school: driving_school,
      status: :active,
      employee: employee
    )
  end
  let(:student) { create(:student) }
  let!(:student_driving_school) do
    create(:student_driving_school,
      driving_school: driving_school,
      status: :active,
      student: student
    )
  end

  let(:other_student) { create(:student) }
  let!(:other_student_driving_school) do
    create(:student_driving_school,
      driving_school: driving_school,
      status: :active,
      student: other_student
    )
  end

  let(:driving_lesson) do
    create(:driving_lesson,
      employee: employee,
      student: student,
      driving_school: driving_school,
      status: :active
    )
  end

  let(:other_driving_lesson) do
    create(:driving_lesson,
      employee: employee,
      student: student,
      driving_school: driving_school,
      status: :active
    )
  end

  let!(:lesson_notes) { create_list(:lesson_note, 5, driving_lesson: driving_lesson, driving_school: driving_school) }

  let(:params) { {} }
  let(:index_request) do
    ->(school_id: driving_school.id, lesson_id: driving_lesson.id) {
      get api_v1_driving_school_driving_lesson_lesson_notes_path(school_id, lesson_id),
        headers: current_user.create_new_auth_token,
        params: params
    }
  end

  let(:current_user) { employee }

  context 'authorization' do
    before { index_request.call }

    context 'when current_user is the employee' do
      let!(:current_user) { employee }

      it 'returns unauthorized status' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when current_user is a student assigned to requested lesson' do
      let!(:current_user) { student }

      it 'returns ok status' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when current_user is a student NOT assigned to requested lesson' do
      let!(:current_user) { other_student }

      it 'returns ok status' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end


  context 'with invalid url params' do
    context 'school does NOT exist' do
      context 'HTTP response' do
        before { index_request.call(school_id: 'not-existing-id') }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end
    end

    context 'lesson does NOT exist' do
      context 'HTTP response' do
        before { index_request.call(lesson_id: 'not-existing-id') }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end
    end

    context 'lesson does NOT belong to that school' do
      let!(:driving_lesson_from_diff_org) do
        create(:driving_lesson,
               employee: employee,
               student: student,
               status: :active,
               )
      end

      context 'HTTP response' do
        before { index_request.call(lesson_id: driving_lesson_from_diff_org.id) }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end
    end

    context 'school in url param has no association to current_user' do
      let!(:current_user) { create(:employee) }


      context 'HTTP response' do
        before { index_request.call }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end
    end
  end

  context 'with valid params' do
    let!(:other_lesson_notes_1st_batch) { create_list(:lesson_note, 2, driving_lesson: other_driving_lesson, driving_school: driving_school) }
    let!(:other_lesson_notes_2nd_batch) { create_list(:lesson_note, 2, driving_lesson: other_driving_lesson, driving_school: driving_school) }

    context 'page 1' do
      let!(:params) { { page: 1, per: 2 } }
      before { index_request.call(lesson_id: other_driving_lesson) }

      it 'returns notes belonging to requested lesson' do
        expect(json_response['results'].pluck('id')).to contain_exactly *other_lesson_notes_2nd_batch.pluck('id')
      end

      it 'returns proper pagination data' do
        expect(json_response['pagination']['is_more']).to eq true
      end
    end

    context 'page 2' do
      let!(:params) { { page: 2, per: 2 } }
      before { index_request.call(lesson_id: other_driving_lesson) }

      it 'returns notes belonging to requested lesson' do
        expect(json_response['results'].pluck('id')).to contain_exactly *other_lesson_notes_1st_batch.pluck('id')
      end

      it 'returns proper pagination data' do
        expect(json_response['pagination']['is_more']).to eq false
      end
    end
  end
end