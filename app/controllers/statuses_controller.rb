class StatusesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_status
  layout "admin_layout"

  def edit
  end

  def update
    if @status.update(status_params)
      UserMailer.with(user_id: @status.user_id).user_approved.deliver_now
      redirect_to admin_dashboard_path, notice: "Admin successfully approved #{@status.user.username}."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: "You are not authorized to perform this action." unless current_user.admin?
  end

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:status_type)
  end
end
