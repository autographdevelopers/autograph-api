class Api::V1::InventoryItemsController < ApplicationController
  before_action :set_driving_school
  before_action :set_inventory_item, only: %i[update attach_file attach_file_web delete_file discard show]
  has_scope :with_any_tags, type: :array do |controller, scope, value|
    scope.tagged_with(value, any: true)
  end
  has_scope :search_term

  def create
    authorize InventoryItem
    @inventory_item = @driving_school.inventory_items.create!(
      inventory_item_params.merge(
        author: current_user,
      )
    )
  end

  def update
    authorize @inventory_item
    @inventory_item.update!(inventory_item_params)
  end

  def index
    authorize InventoryItem
    @inventory_items = @driving_school.inventory_items.includes(
      :author,
      files_attachments: :blob,
      tags: :taggings # https://github.com/mbleigh/acts-as-taggable-on/issues/91#issuecomment-668683692
    ).preload(source_relationships: :target).kept.order(created_at: :desc)
    @inventory_items = apply_scopes(@inventory_items)
    @inventory_items = @inventory_items.page(params[:page]).per(records_per_page)
  end

  def attach_file
    authorize @inventory_item
    @inventory_item.files.attach(io: image_io, filename: image_name)
  end

  def attach_file_web
    authorize @inventory_item
    @inventory_item.files.attach(params[:inventory_item][:file])
  end

  def delete_file
    authorize @inventory_item
    @inventory_item.files.find(upload_doc_attachment[:file_id]).purge_later
  end

  def show
    authorize @inventory_item
  end

  def discard
    authorize @inventory_item
    @inventory_item.discard!
    head :ok
  end

  private

  def image_io
    decoded_image = Base64.decode64(params[:inventory_item][:file][:base64])
    StringIO.new(decoded_image)
  end

  def image_name
    params[:inventory_item][:file][:file_name]
  end

  def inventory_item_params
    params.require(:inventory_item).permit(
      :name,
      :description,
      tag_list: [],
      properties_groups: [
        :title,
        :order,
        data: [:propertyName, :propertyValue, :order]
      ],
      source_relationships_attributes: [
        :id,
        :_destroy,
        :verb,
        :target_type,
        :target_id,
      ]
    )
  end

  def upload_doc_attachment
    params.require(:inventory_item).permit(:file, :file_id)
  end

  def set_inventory_item
    @inventory_item = @driving_school.inventory_items.kept.find(params[:id])
  end

  def set_driving_school
    @driving_school = current_user.user_driving_schools
                          .active_with_active_driving_school
                          .find_by!(driving_school_id: params[:driving_school_id])
                          .driving_school
  end
end
