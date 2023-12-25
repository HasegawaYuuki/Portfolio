class Public::ReviewCommentsController < ApplicationController
  before_action :authenticate_customer!

  def create
    @review = Review.find(params[:review_id])
    @comment = @review.review_comments.new(review_comment_params)
    @comment.customer_id = current_customer.id
    @comment.save
    #redirect_back(fallback_location: review_path(@review.id))
  end

  def destroy
    @review = Review.find(params[:review_id])
    @comment = ReviewComment.find(params[:id])
    @comment.destroy
    flash.now[:notice] = "コメントを削除しました。"
    #redirect_back(fallback_location: review_path(@review.id))
  end

  private

  def review_comment_params
    params.require(:review_comment).permit(:comment, :customer_id, :review_id)
  end

end
