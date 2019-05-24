class SoftwareRequestsController < ApplicationController

  def create
    #@software_request = SoftwareRequest.new
    #@software_request.user = current_user
    #@software_request.computer_id = computer_id
    #byebug
    #@software_request.save(software_request_params)
    #  software_request_params.require(:title)

    @software_request = SoftwareRequest.new(software_request_params)
    @software_request.user = current_user
    @software_request.computer_id = computer_id

    if @software_request.save!
      redirect_to "/computers/#{computer_id}", notice: 'Your request successfully sent.'
    else
      redirect_to "/computers/#{computer_id}", notice: 'Error'
    end
  end

  def software_request_params
    params.require(:software_request).permit(:title, :url, :description, :computer_id)
  end

  def computer_id
    params.require(:computer_id)
  end

end
