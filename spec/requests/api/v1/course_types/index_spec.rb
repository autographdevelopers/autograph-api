describe 'GET /api/v1/driving_schools/:driving_school_id/course_types' do
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
    -> { get api_v1_driving_school_course_types_path(driving_school), headers: current_user.create_new_auth_token, params: params }
  end

  context 'Filtering' do
    let!(:course_type_a) { create(:course_type, name: 'A', driving_school: driving_school) }
    let!(:course_type_b) { create(:course_type, name: 'B', driving_school: driving_school) }
    let!(:course_type_a2) { create(:course_type, name: 'A', driving_school: nil) }
    let!(:course_type_b2) { create(:course_type, name: 'B', driving_school: nil) }
    let!(:course_type_c1) { create(:course_type, name: 'C', driving_school: nil) }

    before { index_request.call }

    context 'no filters' do
      let(:params) { { } }

      it 'returns all assigened course_type' do
        expect(json_response['results'].pluck('id')).to contain_exactly course_type_a.id, course_type_b.id
      end

      it 'returns 200 http status' do
        expect(response).to have_http_status :ok
      end
    end

    context 'only_prebuilts' do
      let(:params) { { only_prebuilts: true } }

      it 'returns unassigned prebuilts' do
        expect(json_response['results'].pluck('id')).to contain_exactly course_type_a2.id, course_type_b2.id, course_type_c1.id
      end

      it 'returns 200 http status' do
        expect(response).to have_http_status :ok
      end
    end

    context 'unassigned prebuilts' do
      let(:params) { { only_prebuilts: true, reject_names: ['A', 'B'] } }

      it 'returns unassigned prebuilts' do
        expect(json_response['results'].pluck('id')).to eq [course_type_c1.id]
      end

      it 'returns 200 http status' do
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'Pagination' do
    let!(:page_elements) { 2 }
    let!(:batch_1_active_course_types) { create_list(:course_type, page_elements, driving_school: driving_school) }
    let!(:batch_2_active_course_types) { create_list(:course_type, page_elements, driving_school: driving_school) }
    let!(:batch_3_active_course_types) { create_list(:course_type, page_elements, driving_school: driving_school) }

    context '1st page' do
      let(:params) { { page: 1, per: page_elements } }

      before { index_request.call }

      it 'returns records from 1st page' do
        expect(json_response['results'].pluck('id')).to eq batch_3_active_course_types.reverse.pluck :id
      end

      it 'returns pagination data indicating has_more -> true' do
        expect(json_response['pagination']['is_more']).to eq true
      end
    end

    context '2nd page' do
      let(:params) { { page: 2, per: page_elements } }

      before { index_request.call }

      it 'returns records from 2nd page' do
        expect(json_response['results'].pluck('id')).to eq batch_2_active_course_types.reverse.pluck :id
      end

      it 'returns pagination data indicating has_more -> true' do
        expect(json_response['pagination']['is_more']).to eq true
      end
    end

    context '3rd page (last)' do
      let(:params) { { page: 3, per: page_elements } }

      before { index_request.call }

      it 'returns records from 2nd page' do
        expect(json_response['results'].pluck('id')).to eq batch_1_active_course_types.reverse.pluck :id
      end

      it 'returns pagination data indicating has_more -> false' do
        expect(json_response['pagination']['is_more']).to eq false
      end
    end
  end

  context 'Authorization' do
    context 'when is a student' do
      let(:current_user) { student }

      it 'returns unauthorized status' do
        index_request.call
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
