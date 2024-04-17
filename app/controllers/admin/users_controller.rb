class Admin::UsersController < AdminsController
  before_action :set_trader, except: [:index]
  layout "admin_layout"

  def index
    @traders = case params[:filter]
              when "pending"
                User.pending_traders
              when "confirmed_email"
                User.confirmed_email_traders
              when "approved"
                User.approved_traders
              else
                User.sorted_traders
              end

    @pagy, @traders = pagy_array(@traders) || pagy(@traders)
  end

  def show
  end

  def edit
  end

  def update
    if @trader.update(trader_params)
      flash[:notice] = "Admin has successfully updated the details of #{@trader.email}."
      redirect_to admin_users_path
    else
      flash[:alert] = @trader.errors.full_messages.join(". ")
      render :edit, status: 422
    end
  end

  def destroy
    @trader.destroy
    redirect_to admin_users_path, notice: "Admin permanently deleted #{@trader.email}."
  end

  private

  def set_trader
    @trader = User.includes(:status).find(params[:id])
  end

  def trader_params
    params.require(:user).permit(:username, :email, status_attributes: [:status_type, :id])
  end
end
