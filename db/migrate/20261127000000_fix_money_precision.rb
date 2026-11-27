class FixMoneyPrecision < ActiveRecord::Migration[8.0]
  def up
    if select_value(<<~SQL).to_i > 0
      SELECT COUNT(*) FROM transactions
      WHERE amount != ROUND(amount, 2) OR ABS(amount) > 9999999999999.99
    SQL
      raise ActiveRecord::IrreversibleMigration, "Existing transaction amounts must fit decimal(15, 2)"
    end

    if select_value("SELECT COUNT(*) FROM accounts WHERE ABS(balance) > 9999999999999.99").to_i > 0
      raise ActiveRecord::IrreversibleMigration, "Existing balances must fit decimal(15, 2)"
    end

    change_column :accounts, :balance, :decimal, precision: 15, scale: 2, default: 0
    change_column :transactions, :amount, :decimal, precision: 15, scale: 2, default: 0
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Converting balances back to integers would lose cents"
  end
end
