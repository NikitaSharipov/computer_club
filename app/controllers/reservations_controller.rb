class ReservationsController < ApplicationController

  after_action :publish_reservation, only: [:create]

  load_and_authorize_resource

  def index
    @date = Time.now.strftime("%-m %d")
    @computers = Computer.all
  end

  def date
    @date = params["date_reservations(2i)"] + ' ' + params["date_reservations(3i)"]
    @computers = Computer.all

    render :index
  end

  def create

    @reservation = Reservation.new
    @reservation.computer_id = params[:computer_id]
    @reservation.user =
      if params["user_id"]
        User.where(id: params["user_id"]).first
      else
        current_user
      end

    start_time = params[:start_time].to_datetime.change(month: params["date(2i)"].to_i, day: params["date(3i)"].to_i)

    @reservation.start_time = start_time

    @reservation.end_time_calculation(params[:duration].to_i)

    if @reservation.valid?
      @reservation.save!
      redirect_to reservations_path, notice: 'You reserved a computer.'
    else
      redirect_to reservations_path, notice: "#{@reservation.errors.full_messages}"
    end
  end

  def destroy
    @reservation.destroy
    redirect_back fallback_location: root_path, notice: 'You successfully delete reservation.'
  end

  def pay
    cost = @reservation.computer.cost
    if current_user.credit_withdrawal(cost.to_i)
      @reservation.update(:payed => true)
      redirect_back fallback_location: root_path, notice: 'Successful payment'
    else
      redirect_back fallback_location: root_path, notice: 'Payment error'
    end
  end

  private

  #def reservation
  #  @reservation = Reservation.find(params[:id])
  #end

  def publish_reservation
    return if @reservation.errors.any?
    ActionCable.server.broadcast(
      'reservations',
      ApplicationController.render(
        partial: 'reservations/reservation',
        locals: { reservation: @reservation, current_user: current_user, date: Time.now.strftime("%-m %d") }
      )
    )
  end
end
