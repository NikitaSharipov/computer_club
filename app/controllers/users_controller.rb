class UsersController < ApplicationController

  def account_replenish
    authorize! :replenish, :account
  end

  def replenish
    authorize! :replenish, :account
    user = income_user

    user.replenish(params["credits"].to_i)
    redirect_back fallback_location: root_path, notice: 'Account replenished.'
  end

  def reservations
    @user = User.find(params[:id])
    authorize! :reservations, @user
  end

end
