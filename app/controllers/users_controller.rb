class UsersController < ApplicationController
  def account_replenish
    authorize! :account_replenish, :user
  end

  def replenish
    user = income_user
    authorize! :replenish, user

    user.replenish(params["credits"].to_i)
    redirect_back fallback_location: root_path, notice: 'Account replenished.'
  end

  def reservations
    @user = User.find(params[:id])
    authorize! :reservations, @user
  end
end
