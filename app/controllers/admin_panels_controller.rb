class AdminPanelsController < ApplicationController

  def show
    authorize! :show, :admin_panel
  end

  def reservation
    authorize! :reservation, :admin_panel
    if params["date_reservations"]
      @date = params["date_reservations"]
    else
      @date = Time.now.strftime("%d-%m-%Y")
    end
    @computers = Computer.all
  end

end
