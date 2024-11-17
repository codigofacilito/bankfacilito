class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :account_number
      t.integer :account_type
      t.integer :balance
      t.string :CLABE

      t.timestamps
    end
  end
end
