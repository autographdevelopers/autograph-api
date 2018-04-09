describe BroadcastActivityJob do
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

  let(:activity) do
    create(:activity,
           driving_school: driving_school,
           target: target,
           user: user,
           activity_type: activity_type)
  end

  context '#perform' do
    before { allow(OneSignal::Notification).to receive(:create) }
    subject { BroadcastActivityJob.perform_now(activity.id) }

    context 'when activity type is student_invitation_sent' do
      let(:activity_type) { :student_invitation_sent }
      let(:user) { employee_3 }
      let(:target) do
        create(:student_driving_school,
               driving_school: driving_school,
               status: :pending)
      end

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_3.id
        ]
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

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_3.id
        ]
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

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_3.id
        ]
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

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_3.id
        ]
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

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_2.id
        ]
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

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_2.id
        ]
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

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_2.id
        ]
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

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_2.id
        ]
      end
    end

    context 'when activity type is driving_course_changed' do
      let(:activity_type) { :driving_course_changed }
      let(:user) { employee_5 }
      let(:target) do
        create(:driving_course,
               student_driving_school: student_driving_school)
      end

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_5.id, student.id
        ]
      end
    end

    context 'when activity type is schedule_changed' do
      let(:activity_type) { :schedule_changed }
      let(:user) { employee_5 }
      let(:target) do
        create(:schedule,
               employee_driving_school: employee_driving_school_4)
      end

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_5.id, employee_4.id
        ]
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

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_5.id, student.id, employee_4.id
        ]
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

      it 'relates Activity with proper users' do
        subject
        expect(activity.notifiable_users.pluck(:id)).to match_array [
          employee_1.id, employee_5.id, student.id, employee_4.id
        ]
      end
    end

    context 'when successfully assigns users to Activity' do
      let(:activity_type) { :driving_lesson_scheduled }
      let(:user) { employee_5 }
      let(:target) do
        create(:driving_lesson,
               student: student,
               employee: employee_4,
               driving_school: driving_school,
               status: :active)
      end

      it 'triggers Activities::SendPushNotificationService' do
        instance = double
        expect(Activities::SendPushNotificationService).to receive(:new).with(activity)
                                                                        .and_return(instance)
        expect(instance).to receive(:call)

        BroadcastActivityJob.perform_now(activity.id)
      end
    end
  end
end
