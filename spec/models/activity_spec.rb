describe Activity do
  context 'enumerators' do
    it {
      should define_enum_for(:activity_type).with(
        %i[
          student_invitation_sent
          student_invitation_withdrawn
          student_invitation_accepted
          student_invitation_rejected
          employee_invitation_sent
          employee_invitation_withdrawn
          employee_invitation_accepted
          employee_invitation_rejected
          driving_course_changed
          schedule_changed
          driving_lesson_canceled
          driving_lesson_scheduled
        ]
      )
    }
  end

  context 'relations' do
    it { should belong_to(:driving_school) }
    it { should belong_to(:target) }
    it { should belong_to(:user) }
    it { should have_many(:notifiable_user_activities) }
    it { should have_many(:notifiable_users) }
    it { should have_many(:related_user_activities) }
    it { should have_many(:related_users) }
  end

  context 'validations' do
    before { allow(subject).to receive(:determine_message).and_return(true) }

    it { should validate_presence_of(:message) }
    it { should validate_presence_of(:activity_type) }
  end

  context 'callbacks' do
    context 'after_create' do
      subject do
        build(:activity,
              target: create(:driving_lesson),
              activity_type: :driving_lesson_scheduled)
      end

      context '#notify_about_activity' do
        it 'should trigger BroadcastActivityJob perform_later' do
          expect(BroadcastActivityJob).to receive(:perform_later).with(kind_of(Integer))
          subject.save!
        end
      end
    end

    context 'before_create' do
      context '#determine_message' do
        let(:driving_school) { create(:driving_school, status: :active) }

        let(:employee_1) { create(:employee) }
        let!(:employee_driving_school_1) do
          create(:employee_driving_school,
                 driving_school: driving_school,
                 status: :active,
                 employee: employee_1,
                 is_owner: true)
        end

        let(:employee_2) { create(:employee) }
        let!(:employee_driving_school_2) do
          create(:employee_driving_school,
                 driving_school: driving_school,
                 status: :active,
                 employee: employee_2,
                 can_manage_employees: true)
        end

        let(:employee_3) { create(:employee) }
        let!(:employee_driving_school_3) do
          create(:employee_driving_school,
                 driving_school: driving_school,
                 status: :active,
                 employee: employee_3,
                 can_manage_students: true)
        end

        let(:employee_4) { create(:employee) }
        let!(:employee_driving_school_4) do
          create(:employee_driving_school,
                 driving_school: driving_school,
                 status: :active,
                 employee: employee_4,
                 is_driving: true)
        end

        let(:employee_5) { create(:employee) }
        let!(:employee_driving_school_5) do
          create(:employee_driving_school,
                 driving_school: driving_school,
                 status: :active,
                 employee: employee_5,
                 can_modify_schedules: true)
        end

        let(:student) { create(:student) }
        let!(:student_driving_school) do
          create(:student_driving_school,
                 driving_school: driving_school,
                 status: :active,
                 student: student)
        end

        subject do
          create(:activity,
                 driving_school: driving_school,
                 target: target,
                 user: user,
                 activity_type: activity_type)
        end

        context 'when activity type is student_invitation_sent' do
          let(:activity_type) { :student_invitation_sent }
          let(:user) { employee_3 }
          let(:target) do
            create(:student_driving_school,
                   driving_school: driving_school,
                   status: :pending)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "Student invitation was sent by <b>#{user.full_name}</b> to " \
              "<b>#{target.student.full_name}</b> at email address <b>#{target.student.email}</b>."
            )
          end
        end

        context 'when activity type is student_invitation_withdrawn' do
          let(:activity_type) { :student_invitation_withdrawn }
          let(:user) { employee_3 }
          let(:target) do
            create(:student_driving_school,
                   driving_school: driving_school,
                   status: :archived)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "Student invitation for <b>#{target.student.full_name}</b> " \
              "was withdrawn by <b>#{user.full_name}</b>."
            )
          end
        end

        context 'when activity type is student_invitation_accepted' do
          let(:activity_type) { :student_invitation_accepted }
          let(:user) { target.student }
          let(:target) do
            create(:student_driving_school,
                   driving_school: driving_school,
                   status: :rejected)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "<b>#{user.full_name}</b> accepted invitation to driving school."
            )
          end
        end

        context 'when activity type is student_invitation_rejected' do
          let(:activity_type) { :student_invitation_rejected }
          let(:user) { target.student }
          let(:target) do
            create(:student_driving_school,
                   driving_school: driving_school,
                   status: :active)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "<b>#{user.full_name}</b> rejected invitation to driving school."
            )
          end
        end

        context 'when activity type is employee_invitation_sent' do
          let(:activity_type) { :employee_invitation_sent }
          let(:user) { employee_2 }
          let(:target) do
            create(:employee_driving_school,
                   driving_school: driving_school,
                   status: :pending)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "Employee invitation was sent by <b>#{user.full_name}</b> to <b>#{target.employee.full_name}</b> " \
              "at email address <b>#{target.employee.email}</b>."
            )
          end
        end

        context 'when activity type is employee_invitation_withdrawn' do
          let(:activity_type) { :employee_invitation_withdrawn }
          let(:user) { employee_2 }
          let(:target) do
            create(:employee_driving_school,
                   driving_school: driving_school,
                   status: :archived)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "Employee invitation for <b>#{target.employee.full_name}</b>" \
              " was withdrawn by <b>#{user.full_name}</b>."
            )
          end
        end

        context 'when activity type is employee_invitation_accepted' do
          let(:activity_type) { :employee_invitation_accepted }
          let(:user) { target.employee }
          let(:target) do
            create(:employee_driving_school,
                   driving_school: driving_school,
                   status: :active)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "<b>#{user.full_name}</b> accepted invitation to driving school."
            )
          end
        end

        context 'when activity type is employee_invitation_rejected' do
          let(:activity_type) { :employee_invitation_rejected }
          let(:user) { target.employee }
          let(:target) do
            create(:employee_driving_school,
                   driving_school: driving_school,
                   status: :rejected)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "<b>#{user.full_name}</b> rejected invitation to driving school."
            )
          end
        end

        context 'when activity type is driving_course_changed' do
          let(:activity_type) { :driving_course_changed }
          let(:user) { employee_5 }
          let(:target) do
            create(:driving_course,
                   student_driving_school: student_driving_school)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "<b>#{user.full_name}</b> changed number of available hours for <b>#{student.full_name}</b> to " \
              "<b>#{target.available_hours}</b>."
            )
          end
        end

        context 'when activity type is schedule_changed' do
          let(:activity_type) { :schedule_changed }
          let(:user) { employee_5 }
          let(:target) do
            create(:schedule,
                   employee_driving_school: employee_driving_school_4)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "<b>#{user.full_name}</b> changed schedule for <b>#{target.employee_driving_school.employee.full_name}</b>."
            )
          end
        end

        context 'when activity type is driving_lesson_canceled' do
          let(:activity_type) { :driving_lesson_canceled }
          let(:user) { employee_5 }
          let(:target) do
            create(:driving_lesson,
                   student: student,
                   employee: employee_4,
                   driving_school: driving_school,
                   status: :canceled)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "<b>#{user.full_name}</b> canceled driving lesson which was to take place on " \
              "<b>#{target.display_duration}</b> between <b>#{target.student.full_name}</b> <b>#{target.employee.full_name}</b>."
            )
          end
        end

        context 'when activity type is driving_lesson_scheduled' do
          let(:activity_type) { :driving_lesson_scheduled }
          let(:user) { employee_5 }
          let(:target) do
            create(:driving_lesson,
                   student: student,
                   employee: employee_4,
                   driving_school: driving_school,
                   status: :active)
          end

          it 'assigns proper message to Activity' do
            expect(subject.message).to eq(
              "<b>#{user.full_name}</b> scheduled driving lesson for " \
              "<b>#{target.student.full_name}</b> and <b>#{target.employee.full_name}</b> on <b>#{target.display_duration}</b>."
            )
          end
        end
      end
    end
  end
end
