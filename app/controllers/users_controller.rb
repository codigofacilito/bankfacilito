class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:register, :login]
  
  def index
  end

  def register
    @user = User.new(user_params)
    @user.pin = params[:pin]

    if @user.save
      @account = @user.accounts.first
      @token = JsonWebToken.encode(user_id: @user.id)
      render :register, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    account = Account.find_by(account_number: params[:account_number])

    if account && account.user.authenticate_pin(params[:pin])
      @user = account.user
      @account = account
      @token = JsonWebToken.encode(user_id: @user.id)
      render :login, status: :ok
    else
      render json: { errors: 'Número de cuenta o PIN incorrecto' }, status: :unauthorized
    end
  end

  def update
    @user = User.find_by(id: params[:id])

    return render json: { errors: 'Solicitud inválida' }, status: :bad_request unless @user && @user.id == @current_user.id

    if @user.update(user_params)
      render :update, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email)
  end
end
