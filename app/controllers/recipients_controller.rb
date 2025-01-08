class RecipientsController < ApplicationController
  
  def index
    @recipients = current_user.recipients
  end

  def create
    @recipient = current_user.recipients.build(recipient_params)

    if @recipient.save
      render json: @recipient, status: :created
    else
      render json: @recipient.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @recipient = current_user.recipients.find_by(id: params[:id])
    
    unless @recipient
      render json: { errors: 'No se encontró el destinatario' }, status: :not_found
      return
    end

    @recipient.destroy
    render json: { message: 'Destinatario eliminado exitosamente' }
  end

  private

  def recipient_params
    params.require(:recipient).permit(:clabe, :name)
  end
end
