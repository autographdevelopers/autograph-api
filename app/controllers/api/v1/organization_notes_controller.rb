class Api::V1::OrganizationNotesController < ApplicationController
  before_action :set_driving_school
  before_action :set_note, only: %i[update show attach_file attach_file_web delete_file discard undiscard publish]
  has_scope :with_status, as: :status

  def create
    authorize OrganizationNote
    @note = @driving_school.organization_notes.create!(
      note_params.merge(
        author: current_user,
      )
    )
  end

  def show
    authorize @note
  end

  def update
    authorize @note
    @note.update!(note_params)
  end

  def index
    @notes = @driving_school.organization_notes.includes(
      :author,
      files_attachments: :blob
    ).order(created_at: :desc)
    @notes = apply_scopes(@notes)
    @notes = @notes.page(params[:page]).per(records_per_page)
  end

  def authored
    @notes = @driving_school.organization_notes.where(
      author: current_user
    ).kept.published.includes(
      :author,
      files_attachments: :blob
    ).order(created_at: :desc)

    @notes = @notes.page(params[:page]).per(records_per_page)
  end

  def publish
    authorize @note
    @note.published!
  end

  def attach_file
    authorize @note
    @note.files.attach(io: image_io, filename: image_name)
  end

  def attach_file_web
    authorize @note
    @note.files.attach(params[:organization_note][:file])
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

  def undiscard
    authorize @note
    @note.undiscard!
    head :ok
  end

  private

  def image_io
    byebug
    decoded_image = Base64.decode64(params[:organization_note][:file][:base64])
    StringIO.new(decoded_image)
  end

  def image_name
    params[:organization_note][:file][:file_name]
  end

  def note_params
    params.require(:organization_note).permit(:title, :body, :datetime)
  end

  def upload_doc_attachment
    params.require(:organization_note).permit(:file, :file_id)
  end

  def set_note
    @note = @driving_school.organization_notes.find(params[:id])
  end

  def set_driving_school
    @driving_school = current_user
                          .user_driving_schools
                          .active_with_active_driving_school
                          .find_by!(driving_school_id: params[:driving_school_id])
                          .driving_school
  end
end
