require 'rails_helper'

RSpec.describe SoftwareRequest, type: :model do

  it { should validate_presence_of :title }
  it { should validate_presence_of :url }

  it { should belong_to(:computer) }
  it { should belong_to(:user) }

end
