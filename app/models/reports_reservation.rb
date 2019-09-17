class ReportsReservation < ApplicationRecord
  belongs_to :report
  belongs_to :reservation
end
