class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers['Authorization']
    if header.present?
      token = header.split(' ').last
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded['user_id'])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: 'Usuario no encontrado' }, status: :unauthorized
      rescue JWT::ExpiredSignature
        render json: { errors: 'Token expirado' }, status: :unauthorized
      rescue JWT::DecodeError
        render json: { errors: 'Token inválido' }, status: :unauthorized
      end
    else
      render json: { errors: 'Token no proporcionado' }, status: :unauthorized
    end
  end
end
