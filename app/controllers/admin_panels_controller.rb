class AdminPanelsController < ApplicationController

  def show
    authorize! :show, :admin_panel
  end

  def reservation
    authorize! :reservation, :admin_panel
    if params["date_reservations(2i)"]
      @date = Reservation.date_prepare(params["date_reservations(1i)"], params["date_reservations(2i)"], params["date_reservations(3i)"])
    else
      @date = Time.now.strftime("%d-%m-%Y")
    end
    @computers = Computer.all
  end

end
