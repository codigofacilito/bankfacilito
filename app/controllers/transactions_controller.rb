class TransactionsController < ApplicationController
  before_action :set_account, only: [:index, :create] 
  before_action :set_transactions, only: :index

  def index
  end

  def create
    recipient_account_id = params[:recipient_account_id]
    @amount = params[:amount].to_f
    description = params[:description]

    @recipient_account = Account.find_by(id: recipient_account_id)

    if @recipient_account.nil?
      render json: { error: 'La cuenta receptora no existe' }, status: :not_found
      return
    end

    if @amount <= 0
      render json: { error: 'El monto debe ser mayor a cero' }, status: :unprocessable_entity
      return
    end

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

  # TODO: Verify user from JWT once implemented
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
