class Admin::RelationshipsController < ApplicationController

  def followings
    @customer = Customer.find_by(id: params[:customer_id])
    @customers = @customer.followings
  end

  def followers
    @customer = Customer.find_by(id: params[:customer_id])
    @customers = @customer.followers
  end

end
