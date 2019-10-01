class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :software_request, dependent: :destroy
  has_many :reservation, dependent: :destroy

  validates :credits, presence: true

  scope :in_date_range, -> (start_date, end_date) { where(created_at: start_date..end_date) }

  def replenish(credits_income)
    self.credits += credits_income
    self.save
  end

  def credit_withdrawal(reservation)
    transaction do
      sum_pay = reservation.sum_pay(reservation.computer.cost)
      return false unless payment_possibility?(sum_pay)
      self.credits -= sum_pay
      self.save!
      reservation.update(:payed => true)
      true
    end
  end

  def reserved_computers
    Computer.where(id: self.reservation.select(:computer_id).map(&:computer_id).uniq).to_a
  end

  private

  def payment_possibility?(sum_pay)
    sum_pay <= credits
  end

end
