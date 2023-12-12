class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
    @spoiler_review = @customer.reviews.where(status: :spoiler)
    @not_spoiler_review = @customer.reviews.where(status: :not_spoiler)
    @draft_review = @customer.reviews.where(status: :draft)
  end

end
