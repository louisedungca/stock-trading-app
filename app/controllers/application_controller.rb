class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.role == "admin"
      admin_dashboard_path
    elsif resource.is_a?(User) && resource.role == "trader"
      trader_dashboard_path
    else
      super
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

end
