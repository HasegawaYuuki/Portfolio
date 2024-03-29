class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def index
    @customer = current_customer
    @customers = Customer.all.where(is_active: true).page(params[:page]).per(10)
  end

  def show
    @customer = Customer.find(params[:id])
    @spoiler_review = @customer.reviews.where(status: :spoiler).page(params[:page]).per(12)
    @spoiler_not_review = @customer.reviews.where(status: :spoiler_not).page(params[:page]).per(12)
    @draft_review = @customer.reviews.where(status: :draft).page(params[:page]).per(12)
  end

  def edit
    @customer = current_customer
  end

  def update
    customer = current_customer
    if customer.update(customer_params)
      flash[:success] = "登録情報変更に成功しました。"
      redirect_to customer_path
    else
      flash[:danger] = "登録情報変更に失敗しました。"
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
    flash[:danger] = "退会処理を実行いたしました"
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

  def ensure_guest_user
    @customer = Customer.find(params[:id])
    if @customer.email == "guest@example.com"
      redirect_to customer_path(current_customer) , danger: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

end
