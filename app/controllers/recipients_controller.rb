class RecipientsController < ApplicationController
  def index
    @recipients = Recipient.where(user: current_user)
  end

  def create
    @recipient = Recipient.new(recipient_params)

    @recipient.user = current_user

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
