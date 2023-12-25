class Admin::ReviewsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @tag_list = Tag.all
    @spoiler_review = Review.where(status: :spoiler).order(created_at: :desc)
    @spoiler_not_review = Review.where(status: :spoiler_not).order(created_at: :desc)
    @draft_review = Review.where(status: :draft).order(created_at: :desc)
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

  def edit
    @review = Review.find(params[:id])
    @customer = @review.customer
  end

  def update
    @review = Review.find(params[:id])
    @review.customer_id = current_admin.id
    if @review.update(review_params)
      flash[:notice] = "ステータス変更に成功しました。"
      redirect_to admin_review_path(@review.id)
    else
      flash[:notice] = "ステータス変更に失敗しました。"
      redirect_to admin_customer_path(@review.customer_id)
    end
  end

   private

  def review_params
    params.require(:review).permit(:status)
  end

end
