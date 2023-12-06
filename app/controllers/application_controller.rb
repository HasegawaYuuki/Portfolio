class ApplicationController < ActionController::Base

  def after_sign_in_path_for(resource)
    if resource == :admin
      about_path
    elsif rosource == :customer
      about_path
    end
  end

end
