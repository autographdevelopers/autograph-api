class Api::V1::NotesController < ApplicationController
  before_action :set_driving_school
  before_action :set_notable
  before_action :set_note, only: :update
  # before_action :authorize_action

  has_scope :lesson_note_from_instructor, only: :index, type: :boolean

  def create
    @note = @notable.notes.create!(note_params.merge(author: current_user, driving_school: @driving_school))
  end

  def index
    @notes = @notable.notes.includes(:notable, :author)
    @notes = apply_scopes(@notes)
    @notes = @notes.page(params[:page] || 1)                                                                                                                                                                                              .per(params[:per] || 25)
  end

  def update
    sleep_for = rand 4
    sleep sleep_for
    raise ActiveRecord::RecordInvalid if sleep_for == 3
    @note.update!(note_params)
  end

  private

  # DrivingLessonPolicy
  # "create_params[:context]?"

  # Possible index example: driving_schools/12/driving_lessons/44/notes?context=lesson_note_from_instructor
  # Possible create example: driving_schools/12/driving_lessons/44/notes
  #
  def authorize_action
    authorize @notable, "#{params[:action]}_#{params[:note][:context]}?"
  end

  def note_params
    params.require(:note).permit(:title, :body, :context, :datetime)
  end

  def set_note
    @note = @notable.notes.find(params[:id])
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
      params["#{notable.underscore}_id"].try! do |id|
        @notable = notable.constantize.find_by!(id: id, driving_school: @driving_school)
        break if @notable
      end
    end
  end
end
