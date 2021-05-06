class Api::V1::LessonNotesController < ApplicationController
  before_action :set_driving_school
  before_action :set_lesson, except: :authored
  before_action :set_note, only: %i[update attach_file delete_file publish discard show attach_file_web]

  def create
    authorize LessonNote
    @note = @lesson.lesson_notes.create!(
      note_params.merge(
        author: current_user,
        driving_school: @driving_school
      )
    )
  end

  def update
    authorize @note
    @note.update!(note_params)
  end

  def show
    authorize @note
  end

  def publish
    authorize @note
    @note.published!
  end

  def index
    authorize @lesson, policy_class: LessonNotePolicy
    @notes = @lesson.lesson_notes.includes(
      :author,
      files_attachments: :blob
    ).published.kept.order(created_at: :desc)
    @notes = @notes.page(params[:page]).per(records_per_page)
  end

  def authored
    @notes = @driving_school.lesson_notes.where(
      author: current_user
    ).published.kept.includes(
      :author,
      files_attachments: :blob
    ).order(created_at: :desc)

    @notes = @notes.page(params[:page]).per(records_per_page)
  end

  def attach_file
    authorize @note
    @note.files.attach(io: image_io, filename: image_name)
  end

  def attach_file_web
    authorize @note
    @note.files.attach(params[:lesson_note][:file])
  end

  def delete_file
    authorize @note
    @note.files.find(upload_doc_attachment[:file_id]).purge_later
  end

  def discard
    authorize @note
    @note.discard!
    head :ok
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
    @note = @lesson.lesson_notes.kept.find(params[:id])
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
