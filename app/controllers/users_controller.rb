class UsersController < ApplicationController

  def account_replenish
    authorize! :replenish, :account
  end

  def replenish
    authorize! :replenish, :account
    user =
      if params["user_id"]
        User.where(id: params["user_id"]).first
      else
        current_user
      end

    user.replenish(params["credits"].to_i)
    user.save
    redirect_back fallback_location: root_path, notice: 'Account replenished.'
  end

end
