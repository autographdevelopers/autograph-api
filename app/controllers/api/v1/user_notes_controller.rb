class Api::V1::UserNotesController < ApplicationController
  before_action :set_user
  before_action :set_driving_school
  before_action :set_note, only: %i[update show attach_file_web attach_file delete_file discard publish]

  def create
    authorize UserNote
    @note = current_user.authored_user_notes.create!(
      note_params.merge(
        user: @user,
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
    # authorize @user, policy_class: UserNote
    @notes = @user.received_user_notes.includes(
      :author,
      :user,
      files_attachments: :blob
    ).kept.published.where(driving_school: @driving_school).order(created_at: :desc)

    @notes = @notes.page(params[:page]).per(records_per_page)
  end

  def authored
    @notes = current_user.authored_user_notes.includes(
      :author,
      :user,
      files_attachments: :blob
    ).kept.published.where(driving_school: @driving_school).order(created_at: :desc)

    @notes = @notes.page(params[:page]).per(records_per_page)
  end

  def attach_file
    authorize @note
    @note.files.attach(io: image_io, filename: image_name)
  end

  def attach_file_web
    authorize @note
    @note.files.attach(params[:user_note][:file])
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
    decoded_image = Base64.decode64(params[:user_note][:file][:base64])
    StringIO.new(decoded_image)
  end

  def image_name
    params[:user_note][:file][:file_name]
  end

  def note_params
    params.require(:user_note).permit(:title, :body, :datetime)
  end

  def upload_doc_attachment
    params.require(:user_note).permit(:file, :file_id)
  end

  def set_note
    @note = @driving_school.user_notes.kept.find(params[:id])
  end

  def set_driving_school
    @driving_school = @user.user_driving_schools
                          .active_with_active_driving_school
                          .find_by!(driving_school_id: params[:driving_school_id])
                          .driving_school
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
