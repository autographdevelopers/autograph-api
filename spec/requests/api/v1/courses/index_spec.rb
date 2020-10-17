describe 'GET /api/v1/driving_schools/:driving_school_id/courses' do
  let(:employee) { create(:employee) }
  let(:student) { create(:student) }
  let(:is_owner) { true }
  let(:params) { {} }
  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: is_owner,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end

  let(:current_user) { employee }

  let(:index_request) do
    -> { get api_v1_driving_school_courses_path(driving_school), headers: current_user.create_new_auth_token, params: params }
  end

  context 'Filtering' do
    let!(:active_courses) { create_list(:course, 2, status: :active, driving_school: driving_school) }
    let!(:archived_courses) { create_list(:course, 2, status: :archived, driving_school: driving_school) }

    context 'Active' do
      let(:params) { { active: true } }

      before { index_request.call }

      it 'returns only active courses' do
        expect(json_response['results'].pluck('status')).to eq Array.new(active_courses.size, 'active')
      end

      it 'returns 200 status' do
        expect(response).to have_http_status :ok
      end
    end

    context 'Archived' do
      let(:params) { { archived: true } }

      before { index_request.call }

      it 'returns only active courses' do
        expect(json_response['results'].pluck('status')).to eq Array.new(active_courses.size, 'archived')
      end

      it 'returns 200 status' do
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'Pagination' do
    let!(:page_elements) { 2 }
    let!(:batch_1_active_courses) { create_list(:course, page_elements, status: :active, driving_school: driving_school) }
    let!(:batch_2_active_courses) { create_list(:course, page_elements, status: :archived, driving_school: driving_school) }
    let!(:batch_3_active_courses) { create_list(:course, page_elements, status: :active, driving_school: driving_school) }

    context '1st page' do
      let(:params) { { page: 1, per: page_elements } }

      before { index_request.call }

      it 'returns records from 1st page' do
        expect(json_response['results'].pluck('id')).to eq batch_3_active_courses.reverse.pluck :id
      end

      it 'returns pagination data indicating has_more -> true' do
        expect(json_response['pagination']['is_more']).to eq true
      end
    end

    context '2nd page' do
      let(:params) { { page: 2, per: page_elements } }

      before { index_request.call }

      it 'returns records from 2nd page' do
        expect(json_response['results'].pluck('id')).to eq batch_2_active_courses.reverse.pluck :id
      end

      it 'returns pagination data indicating has_more -> true' do
        expect(json_response['pagination']['is_more']).to eq true
      end
    end

    context '3rd page (last)' do
      let(:params) { { page: 3, per: page_elements } }

      before { index_request.call }

      it 'returns records from 2nd page' do
        expect(json_response['results'].pluck('id')).to eq batch_1_active_courses.reverse.pluck :id
      end

      it 'returns pagination data indicating has_more -> false' do
        expect(json_response['pagination']['is_more']).to eq false
      end
    end


  end

  context 'Authorization' do
    let!(:course_1) { create(:course, status: :active, driving_school: driving_school) }
    let!(:course_2) { create(:course, status: :active, driving_school: driving_school) }
    let!(:course_participation) { create(:course_participation, course: course_2, student_driving_school: student_driving_school) }

    before { index_request.call }

    context 'when user is an Employee' do
      let(:current_user) { employee }

      it 'has all courses returned' do
        expect(json_response['results'].pluck('id')).to contain_exactly course_1.id, course_2.id
      end
    end

    context 'when user is a Student' do
      let(:current_user) { student }

      it 'has returned only courses she participates in' do
        expect(json_response['results'].pluck('id')).to contain_exactly course_2.id
      end
    end

    context 'when user does not belong to the school' do
      let(:current_user) { create(:employee) }

      it 'returns 404' do
        expect(response).to have_http_status :not_found
      end
    end
  end

  context 'Serialization' do
    let!(:course) { create(:course, status: :active, driving_school: driving_school) }

    before { index_request.call }

    it 'returns properly serialized course record' do
      expect(json_response).to eq (
                                    {
                                      "results" => [
                                        {
                                           "id" => course.id,
                                           "name" => course.name,
                                           "description" =>"Test Description",
                                           "status" =>"active",
                                           "start_time" =>nil,
                                           "end_time" =>nil,
                                           "driving_school_id" => driving_school.id,
                                           "course_type" =>{
                                              "id" => CourseType.first.id,
                                              "name" =>"Test Course",
                                              "description" =>"Test Description",
                                              "status" =>"active"
                                            }
                                          }
                                        ],
                                       "pagination" => { "is_more" => false }
                                    }
                                  )
    end
  end
end