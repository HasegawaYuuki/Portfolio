class Public::ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.customer_id = current_customer.id
    # 受け取った値を,で区切って配列にする
    tag_list = params[:review][:tag_id].split(',')
    if @review.save
       @review.save_tags(tag_list)
      redirect_to review_path(@review.id), notice:'投稿が公開されました'
    elsif @review.draft?
      redirect_to customer_path(current_customer.id), notice:'下書きが保存されました'
    else
      render :new
    end

  end

  def index
    @spoiler_review = Review.where(status: :spoiler).order(created_at: :desc)
    @spoiler_not_review = Review.where(status: :spoiler_not).order(created_at: :desc)
    @tag_list = Tag.reviews.where(status: :spoiler_not).where(status: :spoiler)
    @customer = current_customer
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
    @tag_list = @review.tags.pluck(:name).join(',')
  end

  def update
    @review = Review.find(params[:id])
    @review.customer_id = current_customer.id

    #受け取った値を,で区切って配列にする
    tag_list = params[:review][:tag_id].split(',')
    if @review.update(review_params)
      @review.save_tags(tag_list)
      redirect_to review_path(@review.id), notice:'編集が完了しました'
    elsif @review.draft?
      redirect_to customer_path(current_customer.id), notice:'下書きが保存されました'
    else
      render :edit
    end

  end

  def destroy
    review = Review.find(params[:id])
    review.destroy
    redirect_to customer_path(current_customer.id)
  end

  def search_tag
    #検索結果画面でもタグ一覧表示
    @tag_list = Tag.all
    #検索されたタグを受け取る
    @tag = Tag.find(params[:tag_id])
    #検索されたタグに紐づく投稿を表示
    @spoiler_not_review = @tag.reviews.where(status: :spoiler_)
    @spoiler_review = @tag.reviews.where(status: :spoiler)
  end

  def complete
  end

  private

  def review_params
    params.require(:review).permit(:title, :sub_title, :body, :venue_name, :date, :time, :status, review_images: [])
  end

end
