class AddConfirmedEmailToStatusType < ActiveRecord::Migration[7.1]
  def change
    add_enum_value :status_type, "confirmed_email", after: "approved"
  end
end
