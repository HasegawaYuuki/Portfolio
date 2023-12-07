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
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:title, :sub_title, :body, :venue_name, :tag, :spoiler, :status)
  end

end
