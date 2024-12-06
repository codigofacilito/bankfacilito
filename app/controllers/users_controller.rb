class UsersController < ApplicationController
  
  def index
  end

  def register
    user = User.new(user_params)
    user.pin = params[:pin]

    if user.save
      account = user.accounts.first
      render json: { user: user.first_name, email:user.email, cuenta: account.account_number, message: 'Usuario registrado exitosamente' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    account = Account.find_by(account_number: params[:account_number])

    if account && account.user.authenticate_pin(params[:pin])
      render json: { message: 'Inicio de sesión exitoso' }, status: :ok
    else
      render json: { errors: 'Número de cuenta o PIN incorrecto' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email)
  end
end
