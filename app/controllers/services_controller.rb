class ServicesController < ApplicationController
  skip_before_action :authenticate_request, only: [:index]
  
  def index
    @services = Service.all
    render :index
  end
end
