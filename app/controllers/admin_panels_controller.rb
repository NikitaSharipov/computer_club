class AdminPanelsController < ApplicationController
  def show
    authorize! :show, :admin_panel
  end

  def reservation
    authorize! :reservation, :admin_panel
    @date = params["date_reservations"] || Time.now.strftime("%d-%m-%Y")
    @computers = Computer.all
  end
end
