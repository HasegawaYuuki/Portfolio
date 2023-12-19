class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @reports = Report.all.order(created_at: :desc).page(params[:page]).per(10)
    # 絞り込み機能が使用された場合
    if params[:report_status].present?
      # 選択された report_status に基づいて絞り込み
      @reports = @reports.joins(:review).where(reviews: { report_status: params[:report_status] })
    end
    @customers = Customer.all
    @not_spoiler_review = Review.where(status: :not_spoiler)
    @spoiler_review = Review.where(status: :spoiler)
  end

end
