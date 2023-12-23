class Admin::ReportsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @reports = Report.all.order(created_at: :desc).page(params[:page]).per(10)
    # 絞り込み機能が使用された場合
    if params[:report_status].present?
      # 選択された report_status に基づいて絞り込み
      @reports = @reports.where(reports: { report_status: params[:report_status] })
    end
    @customers = Customer.all
    @not_spoiler_review = Review.where(status: :not_spoiler)
    @spoiler_review = Review.where(status: :spoiler)
  end

  def edit
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      flash[:notice] = "ステータス変更に成功しました。"
      redirect_to admin_reports_path
    else
      flash[:notice] = "ステータス変更に失敗しました。"
      redirect_to admin_review_path(@review.id)
    end
  end

  private

  def report_params
    params.require(:report).permit(:report_status)
  end

end
