class ComputersController < ApplicationController
  before_action :authenticate_user!

  def index
    @computers = Computer.all
  end

  def show
    computer
  end

  def reservation
    if params["date_reservations(2i)"]
      @date = params["date_reservations(2i)"] + ' ' + params["date_reservations(3i)"]
    else
      @date = Time.now.strftime("%-m %d")
    end
    @computers = Computer.all
  end

  def computer
    @computer = Computer.find(params[:id])
  end

  def reserve
    @reservation = Reservation.new
    @reservation.computer_id = params[:computer_id]
    @reservation.user_id = current_user.id

    start_time = params[:start_time].to_datetime.change(month: params["date(2i)"].to_i, day: params["date(3i)"].to_i)

    @reservation.start_time = start_time

    @reservation.end_time_calculation(params[:duration].to_i)

    if @reservation.valid?
      @reservation.save!
      redirect_to reservation_computers_path, notice: 'You reserved a computer.'
    else
      redirect_to reservation_computers_path, notice: "#{@reservation.errors.full_messages}"
    end
  end

  def reservation_params
    params.permit(:computer_id, :start_time, :duration, "date(2i)", "date(3i)")
  end
end
