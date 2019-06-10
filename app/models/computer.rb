class Computer < ApplicationRecord

  validates :cost, :title, :creation, presence: true

  has_many :software_request, dependent: :destroy
  has_many :reservation, dependent: :destroy

end
