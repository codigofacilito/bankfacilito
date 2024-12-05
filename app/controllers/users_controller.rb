class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:register, :login]


  def register
    user = User.new(user_params)
    user.pin = params[:pin]

    if user.save
      account = user.accounts.first
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        message: 'Usuario registrado exitosamente',
        token: token,
        user: {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email
        },
        account: {
          account_number: account.account_number,
          balance: account.balance
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    account = Account.find_by(account_number: params[:account_number])

    if account && account.user.authenticate_pin(params[:pin])
      user = account.user
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        message: 'Inicio de sesión exitoso',
        token: token,
        user: {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email
        }
      }, status: :ok
    else
      render json: { errors: 'Número de cuenta o PIN incorrecto' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :email)
  end
end
