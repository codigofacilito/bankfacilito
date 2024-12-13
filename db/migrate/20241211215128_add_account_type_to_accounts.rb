class AddAccountTypeToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_column :accounts, :account_type, :integer, default: 0, null: false
  end
end
