class Admin::UsersController < ApplicationController
  layout "dashboard_layout"

  def index
    @traders = User.where(role: "trader").order(:created_at)
  end

  def edit
    @trader = User.find(params[:id])
  end

  def update
    @trader = User.find(params[:id])
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

  def trader_params
    params.require(:user).permit(:username, :email, :password)
  end
end
