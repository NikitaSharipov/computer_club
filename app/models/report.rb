class Report < ApplicationRecord
  belongs_to :user
  has_many :reports_reservation, dependent: :destroy

  validates :title, :start_date, :end_date, presence: true
end
