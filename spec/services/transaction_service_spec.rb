require 'rails_helper'

RSpec.describe TransactionService do
  let(:origin) { create(:account, user: nil, balance: 100) }
  let(:recipient) { create(:account, user: nil, balance: 20) }

  describe '#transfer!' do
    it 'persists fractional balances and matching ledger entries' do
      described_class.new.transfer!(origin, recipient, '10.50', 'Transfer')

      expect(origin.reload.balance).to eq(BigDecimal('89.50'))
      expect(recipient.reload.balance).to eq(BigDecimal('30.50'))
      expect(origin.transactions.last.amount).to eq(BigDecimal('10.50'))
      expect(recipient.transactions.last.amount).to eq(BigDecimal('10.50'))
      expect(origin.transactions.last).to be_withdraw
      expect(recipient.transactions.last).to be_deposit
    end

    it 'credits service accounts with the exact amount' do
      recipient.update!(account_type: :service)
      described_class.new.transfer!(origin, recipient, BigDecimal('0.01'))

      expect(origin.reload.balance).to eq(BigDecimal('99.99'))
      expect(recipient.reload.balance).to eq(BigDecimal('20.01'))
      expect(recipient.transactions.last).to be_service_payment
    end

    it 'rejects invalid amounts without changing balances or creating transactions' do
      [ nil, '', 'abc', '10.501', '0.001', '0', '-1', 'NaN', 'Infinity', '10000000000000' ].each do |amount|
        expect { described_class.new.transfer!(origin, recipient, amount) }.to raise_error(InvalidAmountError)
      end

      expect(origin.reload.balance).to eq(100)
      expect(recipient.reload.balance).to eq(20)
      expect(Transaction.count).to eq(0)
    end

    it 'rejects transfers that would overflow the recipient balance' do
      recipient.update!(balance: BigDecimal('9999999999999.99'))

      expect { described_class.new.transfer!(origin, recipient, '0.01') }.to raise_error(InvalidAmountError)
      expect(origin.reload.balance).to eq(100)
      expect(Transaction.count).to eq(0)
    end

    it 'still rejects insufficient funds and transfers to the same account' do
      expect { described_class.new.transfer!(origin, recipient, '100.01') }.to raise_error(InsufficientFundsError)
      expect { described_class.new.transfer!(origin, origin, '1.00') }.to raise_error(InvalidTransactionError)
    end
  end
end
