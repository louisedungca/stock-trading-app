  class Admin::UsersController < ApplicationController
    before_action :set_trader, except: [:index]
    layout "dashboard_layout"

    def index
      @pending_traders = User.pending_traders
      @confirmed_email_traders = User.confirmed_email_traders
      @approved_traders = User.approved_traders

      @traders = User.sorted_traders
      @pagy, @traders = pagy_array(@traders)
    end

    def edit; end

    def update
      if params[:user][:status_attributes][:status_type] == "approved"
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
    @trader.destroy
    redirect_to admin_users_path, notice: "User permanently deleted."
  end

  private

  def set_trader
    @trader = User.includes(:status).find(params[:id])
  end

  def trader_params
    params.require(:user).permit(:username, :email, :password, status_attributes: [:status_type])
  end
end
