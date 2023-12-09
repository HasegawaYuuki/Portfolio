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
      redirect_to reviews_path, notice:'投稿が完了しました'
    else
      render :new
    end
  end

  def index
    @reviews = Review.all
    @tag_list = Tag.all
  end

  def show
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
      @old_relations=Tagging.where(review_id: @review.id)
      #それらを取り出し、消す。消し終わる
      @old_relations.each do |relation|
      relation.delete
      end
       @review.save_tags(tag_list)
      redirect_to reviews_path, notice:'編集が完了しました'
    else
      render :edit
    end
  end

  def destroy
    review = Review.find(params[:id])
    review.destroy
    redirect_to reviews_path
  end

  private

  def review_params
    params.require(:review).permit(:title, :sub_title, :body, :venue_name, :tag, :spoiler, :status)
  end

end
