class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customers = Customer.order(created_at: :desc).all.page(params[:page]).per(10)
  end

  def show
    @customer = Customer.find(params[:id])
    @spoiler_review = @customer.reviews.where(status: :spoiler)
    @not_spoiler_review = @customer.reviews.where(status: :not_spoiler)
    @draft_review = @customer.reviews.where(status: :draft)
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:admin_customer] = "更新成功"
      redirect_to admin_customer_path(@customer)
    else
      render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name,:is_active)
  end

end
