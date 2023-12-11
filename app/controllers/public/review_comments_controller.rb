class Public::ReviewCommentsController < ApplicationController

  def create
    @review = Review.find(params[:review_id])
    comment = current_customer.review_comments.new(review_comment_params)
    comment.review_id = @review.id
    comment.save
    flash.now[:notice] = "コメントの投稿に成功しました。"
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
