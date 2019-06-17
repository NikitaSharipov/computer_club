class SoftwareRequestsController < ApplicationController
  def create
    @software_request = SoftwareRequest.new(software_request_params)
    @software_request.user = current_user
    @software_request.computer = computer

    if @software_request.save!
      redirect_to computer_path(computer), notice: 'Your request successfully sent.'
    else
      redirect_to computer_path(computer), notice: 'Error'
    end
  end

  def software_request_params
    params.require(:software_request).permit(:title, :url, :description, :computer_id)
  end

  private

  def computer_id
    params.require(:computer_id)
  end

  def computer
    Computer.find(computer_id)
  end
end
