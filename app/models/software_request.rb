class SoftwareRequest < ApplicationRecord
  belongs_to :user
  belongs_to :computer

  validates :title, :url, presence: true
end
