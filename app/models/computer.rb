class Computer < ApplicationRecord

  validates :cost, :title, :creation, presence: true

end
