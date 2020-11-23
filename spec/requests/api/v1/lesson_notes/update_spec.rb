describe 'PUT /api/v1/driving_schools/:driving_school_id/driving_lessons/:driving_lesson_id/lesson_notes/:id' do
  let(:driving_school) { create(:driving_school, status: :active) }
  let(:employee) { create(:employee) }
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           driving_school: driving_school,
           status: :active,
           employee: employee)
  end

  let(:employee_not_being_author) { create(:employee) }
  let!(:employee_not_being_author_driving_school) do
    create(:employee_driving_school,
           driving_school: driving_school,
           status: :active,
           employee: employee_not_being_author)
  end

  let(:student) { create(:student) }
  let!(:student_driving_school) do
    create(:student_driving_school,
           driving_school: driving_school,
           status: :active,
           student: student)
  end
  let(:driving_lesson) do
    create(:driving_lesson,
       employee: employee,
       student: student,
       driving_school: driving_school,
       status: :active
    )
  end

  let(:current_user) { employee }

  let(:create_params) {
    {
      lesson_note: {
        title: 'test-title',
        body: 'test-body',
        datetime: Time.current
      }
    }
  }

  let(:create_request) do
    ->(user: current_user, school_id: driving_school.id, lesson_id: driving_lesson.id) {
      post api_v1_driving_school_driving_lesson_lesson_notes_path(school_id, lesson_id),
        params: create_params,
        headers: user.create_new_auth_token
    }
  end

  let(:updated_title) { create_params[:lesson_note][:title] + '-updated' }
  let(:updated_body) { create_params[:lesson_note][:body] + '-updated' }

  let(:update_params) do
    {
      lesson_note: {
        title: updated_title,
        body: updated_body,
      }
    }
  end

  let(:update_request) do
    ->(user: current_user, school_id: driving_school.id, lesson_id: driving_lesson.id, note_id: note_to_be_updated.id) {
      p note_id
      put api_v1_driving_school_driving_lesson_lesson_note_path(school_id, lesson_id, note_id),
        params: update_params,
        headers: user.create_new_auth_token
    }
  end

  let(:note_to_be_updated) { LessonNote.first }

  before { create_request.call(user: employee) }

  context 'authorization' do
    before { update_request.call }

    context 'when current_user is a student' do
      let!(:current_user) { student }

      it 'returns unauthorized status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when current_user is an employee but not author of a note' do
      let!(:current_user) { employee_not_being_author }

      it 'returns unauthorized status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when current_user is an author of a note' do
      let!(:current_user) { employee }

      it 'returns ok status' do
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'with invalid form body params' do
    context 'title is blank' do
      let!(:updated_title) { '' }

      context 'DB changes' do
        it 'does NOT create a new record' do
          expect { update_request.call }.not_to change { note_to_be_updated.title }
        end
      end

      context 'HTTP response' do
        before { update_request.call }

        it 'returns 422 HTTP response status' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns HTTP response body containing error' do
          expect(json_response).to eq ({ 'title' => ["can't be blank"] })
        end
      end
    end
  end

  context 'with invalid url params' do
    context 'school does NOT exist' do

      context 'HTTP response' do
        before { update_request.call(school_id: 'not-existing-id') }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT update the record' do
          expect {
            update_request.call(school_id: 'not-existing-id')
          }.not_to change { note_to_be_updated.reload.body }
        end
      end
    end

    context 'lesson does NOT exist' do
      context 'HTTP response' do
        before { update_request.call(lesson_id: 'not-existing-id') }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT update the record' do
          expect {
            update_request.call(lesson_id: 'not-existing-id')
          }.not_to change { note_to_be_updated.reload.body }
        end
      end
    end

    context 'note does NOT exist' do
      context 'HTTP response' do
        before { update_request.call(note_id: 'not-existing-id') }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT update the record' do
          expect {
            update_request.call(note_id: 'not-existing-id')
          }.not_to change { note_to_be_updated.reload.body }
        end
      end
    end

    context 'lesson does NOT belong to that school' do
      let!(:other_driving_lesson) do
        create(:driving_lesson,
          employee: employee,
          student: student,
          status: :active,
        )
      end

      context 'HTTP response' do
        before { update_request.call(lesson_id: other_driving_lesson.id) }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT update the record' do
          expect {
            update_request.call(lesson_id: other_driving_lesson.id)
          }.not_to change { note_to_be_updated.reload.body }
        end
      end
    end

    context 'school in url param has no association to current_user' do
      let(:user_without_association_to_school) { create(:employee) }

      context 'HTTP response' do
        before { update_request.call(user: user_without_association_to_school) }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT update the record' do
          expect {
            update_request.call(user: user_without_association_to_school)
          }.not_to change { note_to_be_updated.reload.body }
        end
      end
    end

    context 'note in url param has no association to current_user' do
      let!(:other_lesson_note) { create(:lesson_note) }

      context 'HTTP response' do
        before { update_request.call(note_id: other_lesson_note.id) }

        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT update the record' do
          expect {
            update_request.call(note_id: other_lesson_note.id)
          }.not_to change { note_to_be_updated.reload.body }
        end
      end
    end
  end

  context 'with valid url and form body params' do
    context 'DB changes' do
      it 'updates record with expected title value' do
        expect { update_request.call }.to change {
          LessonNote.first&.title
        }.from(create_params[:lesson_note][:title])
         .to(update_params[:lesson_note][:title])
      end

      it 'updates record with expected body value' do
        expect { update_request.call }.to change {
          LessonNote.first&.body
        }.from(create_params[:lesson_note][:body])
         .to(update_params[:lesson_note][:body])
      end
    end

    context 'HTTP response' do
      before { update_request.call }

      it 'returns success HTTP status' do
        expect(response).to have_http_status :ok
      end

      it 'returns proper HTTP response body chunk related to note attributes' do
        expect(json_response).to include(
         'id' => LessonNote.first.id,
         'title' => update_params[:lesson_note][:title],
         'body' => update_params[:lesson_note][:body],
         'datetime' => LessonNote.first.datetime,
         'driving_lesson_id' => LessonNote.first.driving_lesson_id
        )
      end

      it 'returns proper HTTP response body chunk related to author attributes' do
        expect(json_response['author']).to include(
         'id' => current_user.id,
         'email' => current_user.email,
         'name' => current_user.name,
         'surname' => current_user.surname,
        )
      end
    end
  end
end