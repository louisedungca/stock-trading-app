class StatusesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_status

  def edit
  end

  def update
    if @status.update(status_type: "approved")
      redirect_to admin_dashboard_path, notice: "Status was successfully updated."
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
end
