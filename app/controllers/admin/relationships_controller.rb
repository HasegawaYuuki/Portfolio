class Admin::RelationshipsController < ApplicationController
  before_action :authenticate_admin!

  def followings
    @customer = Customer.find_by(id: params[:customer_id])
    @customers = @customer.followings
  end

  def followers
    @customer = Customer.find_by(id: params[:customer_id])
    @customers = @customer.followers
  end

end
