class Computer < ApplicationRecord
  has_many :software_request, dependent: :destroy
  has_many :reservation, dependent: :destroy

  validates :cost, :title, :creation, presence: true
  validates :title, uniqueness: true

  def service_flag
    service_needed_check

    save!
  end

  def service_flag_temporary(full_date)
    full_date = full_date.to_time if full_date.is_a? Date

    service_needed_check(full_date)
  end

  def service_needed_check(full_date = Time.now)
    self.last_service = creation if last_service.nil?

    past_months = (full_date - last_service).to_i / 1.month

    self.service_needed = true if past_months >= service_frequency
  end
end
