class MakeUserIdOptionalForAccounts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :accounts, :user_id, true
  end
end
