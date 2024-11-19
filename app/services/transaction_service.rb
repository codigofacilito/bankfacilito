class TransactionService

  def transfer!(account, recipient, amount, description=nil)
    can_transfer? account, recipient, amount

    ActiveRecord::Base.transaction do
      make_transaction(
        amount,
        account,
        :withdraw,
        description
      )

      make_transaction(
        amount,
        recipient,
        :deposit,
        description
      )
    end

  end
  
  def can_transfer?(account, recipient, amount)
    if account.nil?
      raise StandardError, 'Account not found'
    end

    if recipient.nil?
      raise StandardError, 'Recipient not found'
    end

    if amount <= 0
      raise StandardError, 'Amount must be greater than 0'
    end

    if account.balance < amount
      raise StandardError, 'Insufficient funds'
    end

    if account == recipient
      raise StandardError, 'Cannot transfer to the same account'
    end

    true
  end

  private

      
  def make_transaction(amount, account, transaction_type, description=nil)
    transaction = Transaction.new(
      amount: amount,
      account: account,
      transaction_type: transaction_type,
      description: description,
      status: :pending,
    )

    transaction.save!
  end
end