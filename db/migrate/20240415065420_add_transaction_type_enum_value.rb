class AddTransactionTypeEnumValue < ActiveRecord::Migration[7.1]
  def up
    add_enum_value :transaction_type, "withdraw"
  end
end
