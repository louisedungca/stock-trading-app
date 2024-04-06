class Admin::UsersController < ApplicationController
  layout "dashboard_layout"

  def index
    @traders = User.where(role: "trader")
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
