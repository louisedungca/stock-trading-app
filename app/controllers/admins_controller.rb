class AdminsController < ApplicationController
  before_action :authorize_admin

  private

  def authorize_admin
    redirect_to root_path, alert: "Access denied. You are not authorized to enter this page." unless current_user.admin?
  end
end
