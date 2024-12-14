# == Schema Information
#
# Table name: transactions
#
#  id               :integer          not null, primary key
#  account_id       :integer          not null
#  transaction_type :integer          default("deposit")
#  amount           :decimal(, )      default(0.0)
#  description      :text             default("")
#  status           :integer          default("pending")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Transaction < ApplicationRecord
  belongs_to :account

  enum :status, [:pending, :completed, :failed]
  enum :transaction_type, [:deposit, :withdraw, :transfer, :service_payment]

  after_create :update_balances, if: :pending?

  private

  def update_balances
    return account.deposit!(amount) if deposit?
    return account.withdraw!(amount) if withdraw?
    return account.service_payment!(amount) if service_payment?
  end
end
