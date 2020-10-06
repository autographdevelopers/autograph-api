describe 'GET /api/v1/driving_schools/:driving_school_id/students/:student_id/driving_courses/:id' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let(:driving_course) { student_driving_school.driving_courses.first }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:driving_lesson_1) do
    create(:driving_lesson,
           student: student,
           slots_count: 1,
           driving_school: driving_school,
           status: :active,
           start_time: DateTime.new(2050, 2, 7, 8, 30, 0))
  end

  let!(:driving_lesson_2) do
    create(:driving_lesson,
           student: student,
           slots_count: 2,
           driving_school: driving_school,
           status: :active,
           start_time: DateTime.new(2050, 2, 14, 20, 30, 0))
  end

  let!(:driving_lesson_3) do
    create(:driving_lesson,
           student: student,
           slots_count: 3,
           driving_school: driving_school,
           status: :active,
           start_time: DateTime.new(2050, 2, 18, 7, 30, 0))
  end

  let!(:driving_lesson_4) do
    create(:driving_lesson,
           student: student,
           slots_count: 4,
           driving_school: driving_school,
           status: :active,
           start_time: DateTime.new(2010, 2, 4, 7, 30, 0))
  end

  let!(:driving_lesson_5) do
    create(:driving_lesson,
           student: student,
           slots_count: 5,
           driving_school: driving_school,
           status: :canceled,
           start_time: DateTime.new(2050, 3, 7, 7, 30, 0))
  end

  let!(:driving_lesson_6) do
    create(:driving_lesson,
           student: student,
           slots_count: 6,
           driving_school: driving_school,
           status: :canceled,
           start_time: DateTime.new(2010, 2, 4, 7, 30, 0))
  end

  let(:response_keys) do
    %w[
      id available_hours booked_hours used_hours
    ]
  end

  before do
    get "/api/v1/driving_schools/#{driving_school.id}/students/#{student.id}/driving_courses/#{driving_course.id}",
        headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    it 'returns 200 http status code' do
      expect(response.status).to eq 200
    end

    context 'response body contains proper' do
      subject { json_response }

      it 'keys' do
        expect(subject.keys).to match_array response_keys
      end

      it 'attributes' do
        expect(subject).to include(
          'available_hours' => driving_course.available_hours.to_f.to_s,
          'booked_hours' => 3.0,
          'used_hours' => 2.0,
        )
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

    it 'returns 200 http status code' do
      expect(response.status).to eq 200
    end

    context 'response body contains proper' do
      subject { json_response }

      it 'keys' do
        expect(subject.keys).to match_array response_keys
      end

      it 'attributes' do
        expect(subject).to include(
          'available_hours' => driving_course.available_hours.to_f.to_s,
          'booked_hours' => 3.0,
          'used_hours' => 2.0,
        )
      end
    end
  end
end
