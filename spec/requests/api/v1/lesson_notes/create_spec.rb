describe 'POST /api/v1/driving_schools/:driving_school_id/driving_lessons/:driving_lesson_id/lesson_notes' do
  let(:driving_school) { create(:driving_school, status: :active) }
  let(:employee) { create(:employee) }
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           driving_school: driving_school,
           status: :active,
           employee: employee)
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

  let(:title) { 'test-title' }
  let(:body) { 'test-body' }
  let(:datetime) { Time.current }
  let(:current_user) { employee }

  let(:params) { { lesson_note: { title: title, body: body, datetime: datetime } } }
  let(:create_request) do
    ->(school_id: driving_school.id, lesson_id: driving_lesson.id) {
      post api_v1_driving_school_driving_lesson_lesson_notes_path(school_id, lesson_id),
        params: params,
        headers: current_user.create_new_auth_token
    }
  end

  context 'authorization' do
    before { create_request.call }

    context 'when current_user is a student' do
      let!(:current_user) { student }

      it 'returns unauthorized status' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when current_user is an employee' do
      let!(:current_user) { employee }

      it 'returns ok status' do
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'with invalid form body params' do
    context 'title is blank' do
      let(:title) { '' }

      context 'DB changes' do
        it 'does NOT create a new record' do
          expect { create_request.call }.not_to change { LessonNote.count }
        end
      end

      context 'HTTP response' do
        before { create_request.call }

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
      before { create_request.call(school_id: 'not-existing-id') }

      context 'HTTP response' do
        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT create a new record' do
          expect { create_request.call(school_id: 'not-existing-id') }.not_to change { LessonNote.count }
        end
      end
    end

    context 'lesson does NOT exist' do
      before { create_request.call(lesson_id: 'not-existing-id') }

      context 'HTTP response' do
        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT create a new record' do
          expect { create_request.call(lesson_id: 'not-existing-id') }.not_to change { LessonNote.count }
        end
      end
    end

    context 'lesson does NOT belong to that school' do
      let(:driving_lesson) do
        create(:driving_lesson,
           employee: employee,
           student: student,
           status: :active,
        )
      end

      before { create_request.call }

      context 'HTTP response' do
        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT create a new record' do
          expect { create_request.call }.not_to change { LessonNote.count }
        end
      end
    end

    context 'school in url param has no association to current_user' do
      let(:current_user) { create(:employee) }

      before { create_request.call }

      context 'HTTP response' do
        it 'returns 404 HTTP status' do
          expect(response).to have_http_status :not_found
        end
      end

      context 'DB changes' do
        it 'does NOT create a new record' do
          expect { create_request.call }.not_to change { LessonNote.count }
        end
      end
    end
  end

  context 'with valid url and form body params' do
    context 'DB changes' do
      it 'creates 1 lesson_note record' do
        expect { create_request.call }.to change { LessonNote.count }.from(0).to(1)
      end

      it 'creates record with expected title value' do
        expect { create_request.call }.to change { LessonNote.first&.title }.from(nil).to(title)
      end

      it 'creates record with expected body value' do
        expect { create_request.call }.to change { LessonNote.first&.body }.from(nil).to(body)
      end

      it 'creates record with expected datetime value' do
        expect { create_request.call }.to change { LessonNote.first&.datetime&.to_s }.from(nil).to(datetime.to_s)
      end

      it 'creates record with expected driving_lesson_id value' do
        expect { create_request.call }.to change { LessonNote.first&.driving_lesson_id }.from(nil).to(driving_lesson.id)
      end

      it 'creates record with expected driving_school_id value' do
        expect { create_request.call }.to change { LessonNote.first&.driving_school_id }.from(nil).to(driving_school.id)
      end
    end

    context 'HTTP response' do
      before { create_request.call }

      it 'returns success HTTP status' do
        expect(response).to have_http_status :ok
      end

      it 'returns proper HTTP response body chunk related to note attributes' do
        expect(json_response).to include(
         'id' => LessonNote.first.id,
         'title' => LessonNote.first.title,
         'body' => LessonNote.first.body,
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