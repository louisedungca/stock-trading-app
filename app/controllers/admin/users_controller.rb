  class Admin::UsersController < ApplicationController
    layout "dashboard_layout"

    def index
      @pending_traders = User.pending_traders
      @confirmed_email_traders = User.confirmed_email_traders
      @approved_traders = User.approved_traders

      @traders = @pending_traders + @confirmed_email_traders + @approved_traders
    end

    def edit
      @trader = User.includes(:status).find(params[:id])
    end

    def update
      @trader = User.includes(:status).find(params[:id])

      if params[:user][:status_approved] == "approved"
        @trader.status.update(status_type: "approved")
      end

      if @trader.update(trader_params)
        redirect_to admin_users_path, notice: "User details successfully updated."
      else
        flash[:alert] = @trader.errors.full_messages.join(". ")
        redirect_back(fallback_location: admin_users_path)
      end
    end

  def destroy
    @trader = User.find(params[:id])

    @trader.destroy
    redirect_to admin_users_path, notice: "User permanently deleted."
  end

  private

  def order_by_status_type
    "CASE WHEN statuses.status_type = 'pending' THEN 1 " \
    "WHEN statuses.status_type = 'confirmed_email' THEN 2 " \
    "ELSE 3 END"
  end

  def trader_params
    params.require(:user).permit(:username, :email, :password, :status_type)
  end
end
