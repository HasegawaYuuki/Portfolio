class Public::ReportsController < ApplicationController
  before_action :authenticate_customer!

  def new
   @report = Report.new
   @review = Review.find(params[:review_id])
  end

  def create
    review = Review.find(params[:review_id])
    report = current_customer.reports.new(report_params)
    report.review_id = review.id
    if report.save
      review.update(status: 0)
      flash[:notice] = "管理者に報告しました"
      redirect_to complete_review_path(review)
    else
      @report = Report.new
      @review = Review.find(params[:review_id])
      flash[:alert] = "正しい内容を入力してください"
      render "new"
    end
  end

  private

  def report_params
    params.require(:report).permit(:report)
  end

end
