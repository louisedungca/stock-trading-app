class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout "landing_layout"

  def landing
  end

  def pending_verification
  end

  def market
  end
end
