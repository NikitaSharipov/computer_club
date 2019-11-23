class Report < ApplicationRecord
  belongs_to :user
  # has_many :reports_reservation, dependent: :destroy

  after_create :set_fields

  validates :title, :start_date, :end_date, :kind, presence: true

  validate :validate_sequence, on: :create

  TYPES = %w[reservation computers users].freeze

  def unpayed_reservation_count
    Reservation.by_date(start_date, end_date).where(payed: false).count
  end

  def payed_reservation_count
    Reservation.by_date(start_date, end_date).where(payed: true).count
  end

  def computers
    reservations = Reservation.by_date(start_date, end_date)
    computers_involvement = {}
    reservations.each do |reservation|
      if reservation.payed?
        computers_involvement[reservation.computer] ||= 0
        computers_involvement[reservation.computer] += reservation.duration_hours
      end
    end
    computers_involvement
  end

  def service_needed
    computers = Computer.all.to_a

    computers.each do |computer|
      computer.service_flag_temporary(start_date)
      computers -= [computer] if computer.service_needed == true
      computer.service_flag_temporary(end_date)
      computers -= [computer] if computer.service_needed == false
    end
    computers
  end

  def users_in_date_range
    User.in_date_range(start_date, end_date).to_a
  end

  private

  def set_fields
    return if kind == 'computers'

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
    save!
  end

  def validate_sequence
    if start_date.present? && end_date.present?
      errors.add(:base, :invalid_sequence, message: "start time can not be more than the end time") if start_date > end_date
    end
  end
end
