class Api::V1::NotesController < ApplicationController
  before_action :set_driving_school
  before_action :set_notable

  def create
    raise Pundit::NotAuthorizedError unless create_authorization_functions[[@notable.class.name, params[:context]]]&.call

    @notable.notes.create!(note_params.merge(author: current_user))
  end

  private

  # Possible index example: driving_schools/12/driving_lessons/44/notes?context=lesson_note_from_instructor
  # Possible create example: driving_schools/12/driving_lessons/44/notes

  def index_authorization_functions
    {
      [DrivingLesson, 'lesson_note_from_instructor'] => -> { @notable.student_driving_school.student_id == current_user.id }
    }
  end

  def create_authorization_functions
    {
      [DrivingLesson, 'lesson_note_from_instructor'] => -> { current_user.employee? }
    }
  end

  def note_params
    params.require(:note).permit(:title, :body, :context, :datetime)
  end

  def set_driving_school
    @driving_school = current_user
                          .employee_driving_schools
                          .active_with_active_driving_school
                          .find_by!(driving_school_id: params[:driving_school_id])
                          .driving_school
  end

  def set_notable
    Note::NOTABLE_TYPES.each do |notable|
      params["#{notable.parameterize}_id"].try! do |id|
        @notable = notable.constantize.find_by!(id: id, driving_school: @driving_school)
        break if @notable
      end
    end
  end
end
