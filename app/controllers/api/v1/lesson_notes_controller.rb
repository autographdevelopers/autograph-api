class Api::V1::LessonNotesController < ApplicationController
  before_action :verify_current_user_to_be_employee, only: %i[create update]
  before_action :set_driving_school
  before_action :set_lesson
  before_action :set_note, only: %i[update attach_file delete_file]

  def create
    @note = @lesson.lesson_notes.create!(
      note_params.merge(
        author: current_user,
        driving_school: @driving_school
      )
    )
  end

  def index
    @notes = @lesson.lesson_notes.includes(
      :author,
      files_attachments: :blob
    ).order(created_at: :desc)
    @notes = @notes.page(params[:page]).per(records_per_page)
  end

  def authored
    @notes = @driving_school.lesson_notes.where(
      author: current_user
    ).includes(
      :author,
      files_attachments: :blob
    ).order(created_at: :desc)

    @notes = @notes.page(params[:page]).per(records_per_page)
  end

  def update
    @note.update!(note_params)
  end

  def attach_file
    @note.files.attach(io: image_io, filename: image_name)
  end

  def delete_file
    @note.files.find(upload_doc_attachment[:file_id]).purge_later
  end

  private

  def image_io
    decoded_image = Base64.decode64(params[:lesson_note][:file][:base64])
    StringIO.new(decoded_image)
  end

  def image_name
    params[:lesson_note][:file][:file_name]
  end

  def note_params
    params.require(:lesson_note).permit(:title, :body, :datetime)
  end

  def upload_doc_attachment
    params.require(:lesson_note).permit(:file, :file_id)
  end

  def set_note
    @note = @lesson.lesson_notes.find(params[:id])
  end

  def set_driving_school
    @driving_school = current_user
                          .user_driving_schools
                          .active_with_active_driving_school
                          .find_by!(driving_school_id: params[:driving_school_id])
                          .driving_school
  end

  def set_lesson
    @lesson = @driving_school.driving_lessons.find(params[:driving_lesson_id])
  end
end
