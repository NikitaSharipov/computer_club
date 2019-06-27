class UsersController < ApplicationController

  def account_replenish

  end

  def replenish
    current_user.replenish(params["credits"].to_i)
    current_user.save
    redirect_to account_replenish_users_path, notice: 'You replenish your account.'
  end

end
