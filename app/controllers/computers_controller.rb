class ComputersController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_reservation, only: [:reserve]

  authorize_resource

  def index
    @computers = Computer.all
  end

  def show
    computer
  end

  def create
    @computer = Computer.new(computer_params)
    if @computer.save
      redirect_to computers_path, notice: 'You have added a computer'
    else
      @computer.valid?
      redirect_to computers_path, notice: "#{@computer.errors.full_messages}"
    end
  end

  def destroy
    computer.destroy
    flash[:notice] = 'You successfully delete computer.'
    redirect_to computers_path
  end

  def computer
    @computer = Computer.find(params[:id])
  end

  def payment
    @involved_reservations = Reservation.where(user: current_user)

    @involved_computers = []
    @involved_reservations.each do |reservation|
      unless @involved_computers.include?(reservation.computer)
        @involved_computers << reservation.computer
      end
    end
  end

  def pay
    reservation_id = params[:reservation]
    reservation = Reservation.where(id: reservation_id).first
    cost = reservation.computer.cost
    if current_user.credit_withdrawal(cost.to_i)
      reservation.update(:payed => true)
      redirect_back fallback_location: root_path, notice: 'Successful payment'
    else
      redirect_back fallback_location: root_path, notice: 'Payment error'
    end
  end

  private

  def computer_params
    params.permit(:title, :specifications, :cost, :creation, :last_service, :service_frequency)
  end

  def reservation_params
    params.permit(:computer_id, :start_time, :duration, "date(2i)", "date(3i)")
  end
end
