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

  private

  def account_params
    params.require(:account).permit(:user_id, :account_number, :account_type, :CLABE)
  end
end
