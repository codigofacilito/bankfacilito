class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :transaction_type, default: 0
      t.decimal :amount, default: 0
      t.text :description, default: ''
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
