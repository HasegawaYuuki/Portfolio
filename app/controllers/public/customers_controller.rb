class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @customer = current_customer
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
    @spoiler_review = @customer.reviews.where(status: :spoiler)
    @not_spoiler_review = @customer.reviews.where(status: :not_spoiler)
    @draft_review = @customer.reviews.where(status: :draft)
  end

  def edit
    @customer = current_customer
  end

  def update
    customer = current_customer
    if customer.update(customer_params)
      flash[:edit] = "登録情報変更に成功しました。"
      redirect_to customer_path
    else
      flash[:edit_danger] = "登録情報変更に失敗しました。"
      redirect_to customer_path
    end
  end

  # ブックマーク一覧
  def favorite_index
    @customer = Customer.find(params[:id])
    favorites = Favorite.where(customer_id: @customer.id).pluck(:review_id)
    @favorite_reviews = Review.find(favorites)
  end

  def check
    @customer = current_customer
  end

  # 退会機能
  def withdraw
    current_customer.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :introduction, :image, :email)
  end

  def is_matching_login_user
    customer = Customer.find(params[:id])
    unless customer.id == current_customer.id
      redirect_to customer_path(current_customer.id)
    end
  end



end
