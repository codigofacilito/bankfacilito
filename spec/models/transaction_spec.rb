# == Schema Information
#
# Table name: transactions
#
#  id               :integer          not null, primary key
#  account_id       :integer          not null
#  transaction_type :integer
#  amount           :decimal(, )
#  description      :text
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { User.create(first_name: 'Admin', last_name: 'Admin', pin_digest: '1234') }

  let(:first_account) {
    Account.create(
      user_id: user.id,
      account_number: '1234567890',
      account_type: 1,
      balance: 1_000,
      CLABE: '123456789012345678'
    )
  }

  let(:second_account) {
    Account.create(
      user_id: user.id,
      account_number: '0987654321',
      account_type: 1,
      balance: 1_000,
      CLABE: '098765432109876543'
    )
  }

  describe "#transfer!" do
    it "transfers amount between accounts and updates balances" do
      service = TransactionService.new

      service.transfer!(first_account, second_account, 100)

      # Reload accounts to reflect database changes
      first_account.reload
      second_account.reload

      expect(first_account.balance).to eq(900)
      expect(second_account.balance).to eq(1_100)
    end
  end
end
  
