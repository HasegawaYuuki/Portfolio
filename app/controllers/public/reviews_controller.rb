class Public::ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)
    @review.end_customer_id = current_end_customer.id
    # 受け取った値を,で区切って配列にする
    tag_list = params[:review][:name].split(',')
    if @review.save
      @review.save_tags(tag_list)
      redirect_to reviews_path, notice:'投稿が完了しました'
    else
      render :new
    end
  end
  
  
end
