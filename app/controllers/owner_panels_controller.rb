class OwnerPanelsController < ApplicationController
  def show
    authorize! :show, :owner_panel
  end
end
