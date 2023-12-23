class Admin::ReviewCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @review_comments = ReviewComment.all.order(created_at: :desc).page(params[:page]).per(10)
    @customers = Customer.all
    @reviews = Review
  end

  def destroy
    @review_comment = ReviewComment.find(params[:id])
    @review_comment.destroy
    redirect_to admin_review_comments_path
  end

end
