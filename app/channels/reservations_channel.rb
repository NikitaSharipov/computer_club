class ReservationsChannel < ApplicationCable::Channel
  def follow
    stream_from "reservations"
  end
end
