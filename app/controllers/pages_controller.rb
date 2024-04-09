class PagesController < ApplicationController
  skip_before_action :authenticate_user!, except: [:market]
  layout "landing_layout", except: [:market]

  def landing
  end

  def pending_verification
  end
end
