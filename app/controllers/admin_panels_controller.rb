class AdminPanelsController < ApplicationController

  def show
    authorize! :show, :admin_panel
  end

  def reservation
    if params["date_reservations(2i)"]
      @date = params["date_reservations(2i)"] + ' ' + params["date_reservations(3i)"]
    else
      @date = Time.now.strftime("%-m %d")
    end
    @computers = Computer.all
  end

end
