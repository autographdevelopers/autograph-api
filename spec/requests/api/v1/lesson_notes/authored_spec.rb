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
  let(:other_employee) { create(:employee) }
  let!(:other_employee_driving_school) do
    create(:employee_driving_school,
           driving_school: driving_school,
           status: :active,
           employee: other_employee
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

  let!(:notes_1) { create_list(:lesson_note, 2, driving_lesson: driving_lesson, author: other_employee, driving_school: driving_school) }
  let!(:notes_2) { create_list(:lesson_note, 2, driving_lesson: other_driving_lesson, author: employee, driving_school: driving_school) }

  let(:authored_index_request) do
    ->(school_id: driving_school.id) {
      get authored_api_v1_driving_school_lesson_notes_path(school_id),
        headers: current_user.create_new_auth_token
    }
  end

  let(:current_user) { employee }

  context 'with valid params' do
    before { authored_index_request.call }

    it 'returns notes belonging to author' do
      expect(json_response['results'].pluck('id')).to contain_exactly *notes_2.pluck('id')
    end

    it 'returns proper pagination data' do
      expect(json_response['pagination']['is_more']).to eq false
    end

    it 'returns 200 status code' do
      expect(response).to have_http_status :ok
    end
  end
end
