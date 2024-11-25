class TransactionsController < ApplicationController
  before_action :set_account, only: :index
  before_action :set_transactions, only: :index

  def index
  end

  private

  # TODO: Verify user from JWT once implemented
  def set_account
    @account = Account.find_by(id: params[:account_id])
  end

  def set_transactions
    @transactions = @account.transactions.order(:created_at).page params[:page]
  end
end
