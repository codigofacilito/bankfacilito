class InvalidTransactionError < StandardError; end
class AccountNotFoundError < StandardError; end
class InsufficientFundsError < StandardError; end
class InvalidAmountError < StandardError; end

class TransactionService
  MAX_AMOUNT = BigDecimal("9999999999999.99")

  def transfer!(origin_account, recipient_account, amount, description = nil)
    amount = parse_amount(amount)
    validate_transfer(origin_account, recipient_account, amount)

    ActiveRecord::Base.transaction do
      recipient_type = recipient_account.account_type.to_sym
      transaction_type_dest = recipient_type == :service ? :service_payment : :deposit
      make_transaction(amount, origin_account, :withdraw, description)
      make_transaction(amount, recipient_account, transaction_type_dest, description)
    end

    amount
  end

  private

  def parse_amount(value)
    raise InvalidAmountError, "Amount must be a decimal string or an exact number" if value.is_a?(Float)

    amount = BigDecimal(value.to_s, exception: false)
    unless amount&.finite? && amount.positive? && amount <= MAX_AMOUNT && amount == amount.round(2)
      raise InvalidAmountError, "Amount must be positive, fit within 15 digits, and have at most 2 decimal places"
    end

    amount
  end

  def validate_transfer(origin_account, recipient_account, amount)
    raise AccountNotFoundError, 'Origin account not found' if origin_account.nil?
    raise AccountNotFoundError, 'Recipient account not found' if recipient_account.nil?
    raise InsufficientFundsError, 'Insufficient funds in origin account' if origin_account.balance < amount
    raise InvalidTransactionError, 'Cannot transfer to the same account' if origin_account == recipient_account
    raise InvalidAmountError, "Recipient balance exceeds the maximum" if recipient_account.balance + amount > MAX_AMOUNT
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
