  class Admin::UsersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_trader, except: [:index]
    layout "dashboard_layout"

    def index
      @pending_traders = User.pending_traders
      @confirmed_email_traders = User.confirmed_email_traders
      @approved_traders = User.approved_traders

      @traders = User.sorted_traders
      @pagy, @traders = pagy_array(@traders)
    end

    def edit
    end

    def update
      if @trader.update(trader_params)
        redirect_to admin_users_path, notice: "User details successfully updated."
      else
        flash[:alert] = @trader.errors.full_messages.join(". ")
        redirect_back(fallback_location: admin_users_path)
      end
    end

  def destroy
    @trader.destroy
    redirect_to admin_users_path, notice: "User permanently deleted."
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: 'You are not authorized to perform this action.' unless current_user.admin?
  end

  def set_trader
    @trader = User.includes(:status).find(params[:id])
  end

  def trader_params
    params.require(:user).permit(:username, :email, status_attributes: [:status_type, :id])
  end
end
