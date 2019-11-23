class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      if user.owner?
        owner_abilities
      elsif user.admin?
        admin_abilities
      else
        user_abilities
      end
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
    cannot :show, :owner_panel
  end

  def owner_abilities
    can :manage, :all
  end

  def user_abilities
    can [:read], Computer

    can [:index, :date, :payment], Reservation
    can [:create, :destroy, :pay], Reservation, user_id: user.id

    can [:create], SoftwareRequest

    can :account_replenish, :user
    can :replenish, User, id: user.id
    can :reservations, User, id: user.id
    can :destroy, Reservation, user_id: user.id
  end
end
