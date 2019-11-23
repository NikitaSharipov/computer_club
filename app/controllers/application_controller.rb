class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def income_user
    params["user_id"] ? User.find(params["user_id"]) : current_user
  end
end
