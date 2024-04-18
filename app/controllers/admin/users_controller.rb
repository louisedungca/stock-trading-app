class Admin::UsersController < AdminsController
  before_action :set_trader, except: [:index]
  before_action :ensure_frame_response, only: [:show, :edit]
  layout "admin_layout"

  def index
    @traders = User.sorted_traders

    if params[:filter].present? && User::STATUS_TYPES.include?(params[:filter])
      @traders = User.includes(:status).where(role: :trader, statuses: { status_type: params[:filter] })
    end

    @status_types = User::STATUS_TYPES
    @pagy, @traders = pagy_array(@traders) || pagy(@traders)
  end

  def show
    @stocks = Stock.group_similar_stocks(@trader)
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

  def ensure_frame_response
    return unless Rails.env.development?
    redirect_to admin_users_path unless turbo_frame_request?
  end
end
