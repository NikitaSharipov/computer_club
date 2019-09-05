class Report < ApplicationRecord
  belongs_to :user
  has_many :reports_reservation, dependent: :destroy

  after_create :set_fields

  validates :title, :start_date, :end_date, presence: true

  validate :validate_sequence, :on => :create

  def reservation_count
    reservations = Reservation.by_date(start_date, end_date).count
  end

  private

  def set_fields
    reservations = Reservation.by_date(start_date, end_date)
    return if reservations.count == 0
    # set proceeds and rent length
    self.proceeds = 0
    self.rent_length = 0

    reservations.each do |reservation|
      if reservation.payed?
        self.proceeds += reservation.sum_pay(reservation.computer.cost)
        self.rent_length += reservation.duration_hours
      end
    end
    # set idle length
    # switch from rational to integer and then from days to hours
    sum_hours = (end_date - start_date).to_i * 24
    self.idle_length = sum_hours - rent_length

    self.save!
  end

  def validate_sequence
    if start_date.present? && end_date.present?
      errors.add(:base, :invalid_sequence, message: "start time can not be more than the end time") if start_date > end_date
    end
  end

end
