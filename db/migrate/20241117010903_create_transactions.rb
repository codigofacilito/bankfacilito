class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :transaction_type
      t.decimal :amount
      t.integer :recipient_account_id
      t.text :description
      t.integer :status

      t.timestamps
    end
  end
end
