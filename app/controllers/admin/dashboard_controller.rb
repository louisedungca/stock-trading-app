class Admin::DashboardController < ApplicationController
  def index
    # for checking of role only, remove later
    if current_user && current_user.admin?
      puts "CURRENT_USER.ADMIN? #{current_user.admin?}"
    end

  end
end
