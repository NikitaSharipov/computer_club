# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    #guest_abilities
    can [:read, :reservation, :payment], Computer
    can [:reserve, :pay], Computer, user_id: user.id
    can [:create], SoftwareRequest
    can  :replenish, :account
  end

  def guest_abilities
  end


end
