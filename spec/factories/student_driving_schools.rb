FactoryBot.define do
  factory :student_driving_school do
    student
    driving_school
    status [:pending, :active, :archived].sample

    after(:create) do |student_driving_school, evaluator|
      # student_driving_school.driving_courses.create!(
      #     labelable_label: (student_driving_school.driving_school.course_categories.first&.labelable_labels&.first) || LabelableLabel.create!(labelable: student_driving_school.driving_school, label: Label.create!(name: "Course for category #{%w[A B C].sample}", purpose: :course_category))
      # )
    end
  end
end
