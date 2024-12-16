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

  private

  def recipient_params
    params.require(:recipient).permit(:clabe, :name)
  end
end
