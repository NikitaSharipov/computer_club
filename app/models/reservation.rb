class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :computer

  validates :start_time, :end_time, presence: true
  validates_inclusion_of :payed, in: [true, false]

  validate :validate_sequence, :validate_intersection, :on => :create

  #scope :actual, -> { where(start_time > Time.now)}

  def end_time_calculation(duration)
    self.end_time = start_time + 1.hour * duration
  end

  def show?(date)
    # date == start_time.strftime("%-m %d")
    date = Reservation.date_prepare(date)
    date.to_date >= start_time.to_date && date.to_date <= end_time.to_date
  end

  def show_further?
    date = Reservation.date_prepare(Time.now.strftime("%-m %d"))
    date.to_date <= start_time.to_date
  end

  def self.date_prepare(date)
    date.split(' ').last.length == 1 ? date.insert(-2, '0') : date
  end

  def duration_hours
    ((end_time - start_time) / 3600).to_i
  end

  def sum_pay(cost)
    cost * duration_hours
  end

  private

  def validate_sequence
    if start_time.present? && end_time.present?
      errors.add(:base, :invalid_sequence, message: "start time can not be more than the end time") if start_time > end_time
    end
  end

  def validate_intersection
    #  Reservation.all.each do |reservation|
    if start_time.present? && end_time.present?
      Reservation.where(computer_id: computer.id).each do |reservation|
        errors.add(:base, :invalid_intersection, message: "reservation time intersection") unless (reservation.end_time <= start_time || reservation.start_time >= end_time)
      end
    end
  end
end
