class TransactionService
  def transfer!(origin_account, recipient_account, amount, description = nil)
    validate_transfer(origin_account, recipient_account, amount)

    ActiveRecord::Base.transaction do
      make_transaction(amount, origin_account, :withdraw, description)
      make_transaction(amount, recipient_account, :deposit, description)
    end
  end

  private

  def validate_transfer(origin_account, recipient_account, amount)
    raise AccountNotFoundError, 'Origin account not found' if origin_account.nil?
    raise AccountNotFoundError, 'Recipient account not found' if recipient_account.nil?
    raise InvalidAmountError, 'Amount must be greater than 0' if amount <= 0
    raise InsufficientFundsError, 'Insufficient funds in origin account' if origin_account.balance < amount
    raise InvalidTransactionError, 'Cannot transfer to the same account' if origin_account == recipient_account
  end

  def make_transaction(amount, account, transaction_type, description = nil)
    account.transactions.create!(
      amount: amount,
      transaction_type: transaction_type,
      description: description,
      status: :pending
    )
  end
end
