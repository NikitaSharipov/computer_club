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
      redirect_to computers_path, notice: "#{@computer.errors.full_messages}"
    end
  end

  def destroy
    computer.destroy
    flash[:notice] = 'You successfully delete computer.'
    redirect_to computers_path
  end

  def computer
    @computer ||= Computer.find(params[:id])
  end

  private

  def computer_params
    params.permit(:title, :specifications, :cost, :creation, :last_service, :service_frequency)
  end

  def reservation_params
    params.permit(:computer_id, :start_time, :duration, "date(2i)", "date(3i)")
  end
end
