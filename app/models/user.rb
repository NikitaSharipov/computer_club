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
  end

  def payment_possibility?(cost)
    cost <= credits
  end

  def credit_withdrawal(cost)
    if payment_possibility?(cost)
      self.credits -= cost
      self.save!
      return true
    else
      return false
    end
  end

end
