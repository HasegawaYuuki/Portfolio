class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!

  def index
    @customer = current_customer
    @customers = Customer.all
  end

  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    customer = current_customer
    if customer.update(customer_params)
      flash[:edit] = "登録情報変更に成功しました。"
      redirect_to customers_path
    else
      flash[:edit_danger] = "登録情報変更に失敗しました。"
      redirect_to edit_customers_path
    end
  end

  def withdraw
    current_customer.update(is_active: false)
    reset_session
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :introduction)
  end

end
