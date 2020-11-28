class Api::V1::CommentsController < ApplicationController
  before_action :set_school
  before_action :set_commentable
  before_action :set_comment, only: :discard

  def index
    @comments = @commentable.comments.kept.includes(:author)
    @comments = @comments.page(params[:page]).per(records_per_page)
  end

  def create
    @comment = @commentable.comments.create!(
      comment_params.merge(
        author: current_user,
        driving_school: @school,
      )
    )
  end

  def discard
    @comment.discard!
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_school
    @school = current_user.user_driving_schools
                  .active_with_active_driving_school
                  .find_by!(driving_school_id: params[:driving_school_id])
                  .driving_school
  end

  def set_commentable
    Comment::COMMENTABLE_TYPES.each do |c|
      params["#{c.underscore}_id"].try do |id|
        @commentable = c.constantize.find_by!(driving_school: @school, id: id)
      end
    end
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end
end
