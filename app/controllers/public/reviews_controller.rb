class Public::ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.customer_id = current_customer.id
    # 受け取った値を,で区切って配列にする
    tag_list = params[:review][:name].split(',')
    if @review.save
      @review.save_tags(tag_list)
      redirect_to reviews_path, notice:'投稿が完了しました'
    else
      render :new
    end
  end

  def index
    @reviews = Review.all
  end

  def show
    @reviews = Review.find(params[:id])
    @customer = @reviews.customer
  end

  def edit
    @review = Review.find(params[:id])
    @tag_list = @review.tags.pluck(:name).join(',')
  end

  def update
    @review = Review.find(params[:id])
    @review.customer_id = current_customer.id
    # 受け取った値を,で区切って配列にする
    tag_list = params[:review][:name].split(',')
    if @review.update(review_params)
      @review.save_tags(tag_list)
      redirect_to reviews_path, notice:'投稿が完了しました'
    else
      render :new
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
