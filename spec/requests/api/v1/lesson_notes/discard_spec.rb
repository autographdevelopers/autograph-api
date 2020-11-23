describe 'PUT /api/v1/driving_schools/:driving_school_id/driving_lessons/:driving_lesson_id/lesson_notes/:id/discard' do
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

  let(:driving_lesson) do
    create(:driving_lesson,
      employee: employee,
      student: student,
      driving_school: driving_school,
      status: :active
    )
  end

  let!(:note) { create(:lesson_note, driving_lesson: driving_lesson, author: employee, driving_school: driving_school) }


  let(:discard_request) do
    ->(school_id: driving_school.id, lesson_id: driving_lesson.id, note_id: note.id) {
      put discard_api_v1_driving_school_driving_lesson_lesson_note_path(
            school_id, lesson_id, note_id
          ), headers: current_user.create_new_auth_token
    }
  end

  let(:current_user) { employee }

  context 'when current user is not an author of a note' do
    let(:current_user) { other_employee }

    it 'does NOT discard record' do
      expect { discard_request.call }.not_to change { note.reload.discarded_at }
    end

    it 'return unauthorized status' do
      discard_request.call
      expect(response).to have_http_status :unauthorized
    end
  end

  context 'when current user is an author of a note' do
    let(:current_user) { employee }

    it 'does NOT discard record' do
      expect { discard_request.call }.to change { note.reload.discarded_at }
    end

    it 'return unauthorized status' do
      discard_request.call
      expect(response).to have_http_status :ok
    end
  end
end
