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
  let(:user) { create(:user) }
  let(:first_account) { create(:account, user: user) }
  let(:second_account) { create(:account, user: user) }

  describe "#transfer!" do
    it "transfers between accounts" do
      first_account.transfer!(second_account, 100)

      # Reload accounts to reflect database changes
      first_account.reload
      second_account.reload

      expect(first_account.balance).to eq(900)
      expect(second_account.balance).to eq(1_100)
    end

    it "Invalid transfer using same account" do
      expect {
        first_account.transfer!(second_account, 0)
      }.to raise_error(InvalidAmountError)

      expect {
        first_account.transfer!(first_account, 100)
      }.to raise_error(InvalidTransactionError)
    end

    it "Invalid transfer with insufficient funds" do
      expect {
        first_account.transfer!(second_account, 1_001)
      }.to raise_error(InsufficientFundsError)
    end
  end
end
  
