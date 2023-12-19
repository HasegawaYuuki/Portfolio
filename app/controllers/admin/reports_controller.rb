class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @reports = Report.order("created_at DESC")
    @customers = Customer.all
    @not_spoiler_review = Review.where(status: :not_spoiler)
    @spoiler_review = Review.where(status: :spoiler)
  end

end
