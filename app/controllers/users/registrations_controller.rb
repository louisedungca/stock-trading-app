# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout :set_layout, only: [:edit, :update]

  private

  def set_layout
    if current_user.trader?
      "dashboard_layout"
    else
      "admin_layout"
    end
  end

  def after_inactive_sign_up_path_for(resource)
    pending_verification_page_path
  end
end
