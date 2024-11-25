class TransactionsController < ApplicationController
	before_action :set_account, only: :index
	before_action :set_transactions, only: :index

	def index
	end

	private

	# TODO: Get user from JWT once implemented
	# ? How do we get an account?
	def set_account
		@account = Account.first
	end

	def set_transactions
		@transactions = @account.transactions.order(:created_at).page params[:page]
	end
end
