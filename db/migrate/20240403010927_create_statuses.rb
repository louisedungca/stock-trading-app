class CreateStatuses < ActiveRecord::Migration[7.1]
  def change
    create_enum :status_type, ["pending", "approved"]

    create_table :statuses do |t|
      t.enum :status_type, enum_type: "status_type", null: false, default: "pending"
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
