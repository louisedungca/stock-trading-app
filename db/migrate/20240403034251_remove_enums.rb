class RemoveEnums < ActiveRecord::Migration[7.1]
  def change
    drop_enum :type
    drop_enum :status
  end
end
