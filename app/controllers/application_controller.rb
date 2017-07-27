class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # force session login or FB login
  # 參考 ihower  購物車
  # 保留使用者，刪除登入畫面
  # 設定串金流，一個歡迎大家捐錢的概念

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end
end
