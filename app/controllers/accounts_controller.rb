class AccountsController < ApplicationController
  def show
    @account = Account.find_by(id: params[:id])
  end

  def create
    @account = Account.create(account_params)

    if @account.save
      render json: @account, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def transfer
    @source_account = current_user.accounts.find_by(id: params[:id])
    return render json: { errors: 'Cuenta de origen no encontrada' }, status: :not_found unless @source_account

    recipient_account = Account.find(params[:recipient_account_id])
    @amount = params[:amount].to_d
    description = params[:description]

    perform_transfer(@source_account, recipient_account, @amount, description)
  end

  def pay_service
    @source_account = current_user.accounts.find_by(id: params[:id])
    return render json: { errors: 'Cuenta de origen no encontrada' }, status: :not_found unless @source_account

    begin
      service = Service.find(params[:service_id])
    rescue ActiveRecord::RecordNotFound
      return render json: { errors: 'Servicio no encontrado' }, status: :not_found
    end
  
    @amount = params[:amount].to_d
    description = params[:description]

    perform_transfer(@source_account, service.account, @amount, description)
  end

  private

  def account_params
    params.require(:account).permit(:user_id, :account_number, :account_type, :CLABE)
  end

  def perform_transfer(source_account, recipient_account, amount, description)
    source_account.transfer!(recipient_account, amount, description)
    @recipient_account = recipient_account
    render :transfer, status: :ok
  rescue AccountNotFoundError => e
    render json: { errors: 'Cuenta receptora no encontrada' }, status: :not_found
  rescue InvalidAmountError, InsufficientFundsError, InvalidTransactionError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound
    if block_given?
      yield
    else
      render json: { errors: 'Cuenta receptora no encontrada' }, status: :not_found
    end
  rescue StandardError => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end
end
