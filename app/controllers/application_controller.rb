class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    if resource == :admin
      root_path
    elsif resource == :customer
      customer_path(current_customer.id)
    end
  end

end
