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
    can [:read, :payment], Computer

    can [:index, :date], Reservation
    can [:create, :destroy, :pay], Reservation, user_id: user.id

    can [:create], SoftwareRequest

    can :replenish, :account
    can :reservations, User, id: user.id
    can :destroy, Reservation, user_id: user.id
  end

  def guest_abilities
  end


end
