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

    unless @source_account
      render json: { errors: 'Cuenta de origen no encontrada' }, status: :not_found and return
    end

    recipient_account_number = params[:recipient_account_number]
    amount = params[:amount].to_d
    description = params[:description]

    if amount <= 0
      render json: { errors: 'El monto debe ser mayor que cero' }, status: :unprocessable_entity and return
    end

    begin
      @source_account.transfer!(recipient_account_number, amount, description)
      render :transfer, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Cuenta receptora no encontrada' }, status: :not_found
    rescue StandardError => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:user_id, :account_number, :account_type, :CLABE)
  end
end
