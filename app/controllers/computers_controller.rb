class ComputersController < ApplicationController

  before_action :authenticate_user!

  def index
    @computers = Computer.all
  end

  def show
    computer
  end

  def computer
    @computer ||= params[:id] ? Computer.find(params[:id]) : Computer.new
  end


end
