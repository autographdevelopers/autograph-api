class AddCanStudentBookDrivingLessonToScheduleSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :schedule_settings, :can_student_book_driving_lesson, :boolean, default: true
  end
end
