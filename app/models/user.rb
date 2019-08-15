class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :software_request, dependent: :destroy
  has_many :reservation, dependent: :destroy

  validates :credits, presence: true

  def replenish(credits_income)
    self.credits += credits_income
    self.save
  end

  def payment_possibility?(cost)
    cost <= credits
  end

  def credit_withdrawal(cost)
    return false unless payment_possibility?(cost)
    self.credits -= cost
    self.save!
    true
  end

  def credit_withdrawal(reservation)
    transaction do
      cost = reservation.computer.cost.to_i
      return false unless payment_possibility?(cost)
      self.credits -= cost
      self.save!
      reservation.update(:payed => true)
      true
    end
  end

  def reserved_computers
    Computer.where(id: self.reservation.select(:computer_id).map(&:computer_id).uniq).to_a
  end

end
