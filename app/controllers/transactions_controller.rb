class TransactionsController < ApplicationController
  before_action :set_account, only: [:index, :create] 
  before_action :set_transactions, only: :index

  def index
    @transactions = @account.transactions
  end

  def create
    @amount = params[:amount].to_f
    @recipient = current_user.recipients.find_by(id: params[:recipient_id])
    @recipient_account = @recipient.account
    description = params[:description]

    begin
      @account.transfer!(@recipient_account, @amount, description)
      render :create, status: :ok
    rescue AccountNotFoundError, InvalidTransactionError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue InsufficientFundsError => e
      render json: { error: e.message }, status: :payment_required
    rescue StandardError => e
      Rails.logger.error "Error during transfer: #{e.message}"
      render json: { error: 'Ocurrió un error inesperado' }, status: :internal_server_error
    end
  end

  private

  def set_account
    @account = current_user.accounts.find_by(id: params[:account_id])
    unless @account
      render json: { error: 'Cuenta no encontrada' }, status: :not_found
    end
  end

  def set_transactions
    @transactions = @account.transactions.order(:created_at).page params[:page]
  end
end
