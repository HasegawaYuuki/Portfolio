class Admin::ReviewsController < ApplicationController

  def index
    @tag_list = Tag.all
    @spoiler_review = Review.where(status: :spoiler)
    @not_spoiler_review = Review.where(status: :not_spoiler)
    @draft_review = Review.where(status: :draft)
  end

  def show
    @reviews = Review.all
    @review = Review.find(params[:id])
    @customer = @review.customer
    @tags = @review.tags
    #コメントの作成
    @review_comment = ReviewComment.new
    #コメント一覧表示で使用する全コメントデータを代入（新着順で表示）
    @comments = @review.review_comments.order(created_at: :desc)
  end

end
