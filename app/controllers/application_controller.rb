class ApplicationController < ActionController::Base
  
  def after_sign_in_path_for(resource)
    if resource == :admin
      # 管理者側の遷移先
    elsif rosource == :customer
      # 顧客側の遷移先
    end
  end
  
end
