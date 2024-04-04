# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def after_inactive_sign_up_path_for(resource)
    pending_verification_page_path
  end
end
