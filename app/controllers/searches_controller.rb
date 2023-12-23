class SearchesController < ApplicationController
  before_action :authenticate_customer!

  def search
    @range = params[:range]
    @word = params[:word]

    @spoiler_review = Review.looks(params[:search], params[:word]).where(status: :spoiler)
    @poiler_not_sreview = Review.looks(params[:search], params[:word]).where(status: :spoiler_not)
  end

end
