class Computer < ApplicationRecord
  has_many :software_request, dependent: :destroy
  has_many :reservation, dependent: :destroy

  validates :cost, :title, :creation, presence: true
  validates :title, uniqueness: true
end
