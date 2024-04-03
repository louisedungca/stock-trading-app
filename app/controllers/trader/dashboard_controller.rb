class Trader::DashboardController < ApplicationController
  def index
    # for checking of role only, remove later
    if current_user && current_user.trader?
      puts "CURRENT_USER.TRADER? #{current_user.trader?}"
    end

  end
end
