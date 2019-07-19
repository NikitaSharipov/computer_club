class ReservationsController < ApplicationController
  def destroy
    reservation.destroy
    flash[:notice] = 'You successfully delete reservation.'
    redirect_to reservation_admin_panel_path
  end

  def reservation
    @reservation = Reservation.find(params[:id])
  end
end
