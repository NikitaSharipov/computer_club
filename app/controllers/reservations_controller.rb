class ReservationsController < ApplicationController
  after_action :publish_reservation, only: [:create]

  load_and_authorize_resource

  def index
    @date = Time.now.strftime("%d-%m-%Y")
    @computers = Computer.all
  end

  def date
    @date = params["date_reservations"]
    @computers = Computer.all

    render :index
  end

  def create
    @reservation = Reservation.new
    @reservation.computer_id = params[:computer_id]
    @reservation.user = income_user

    start_time = (params['date'] + ' ' + params['start_time']).to_datetime

    @reservation.start_time = start_time

    @reservation.end_time_calculation(params[:duration].to_i)

    if @reservation.save
      redirect_to reservations_path, notice: 'You reserved a computer.'
    else
      redirect_to reservations_path, notice: @reservation.errors.full_messages.to_s
    end
  end

  def destroy
    @reservation.user.credits += @reservation.sum_pay(@reservation.computer.cost) if @reservation.payed?
    @reservation.user.save!
    @reservation.destroy
    redirect_back fallback_location: root_path, notice: 'You successfully delete reservation.'
  end

  def payment
    @involved_computers = current_user.reserved_computers
  end

  def pay
    if current_user.credit_withdrawal(@reservation)
      redirect_back fallback_location: root_path, notice: 'Successful payment'
    else
      redirect_back fallback_location: root_path, notice: 'Payment error'
    end
  end

  private

  # def reservation
  #  @reservation = Reservation.find(params[:id])
  # end

  def publish_reservation
    return if @reservation.errors.any?

    ActionCable.server.broadcast(
      'reservations',
      ApplicationController.render(
        partial: 'reservations/reservation',
        locals: { reservation: @reservation, current_user: current_user, date: Time.now.strftime("%d-%m-%Y") }
      )
    )
  end
end
