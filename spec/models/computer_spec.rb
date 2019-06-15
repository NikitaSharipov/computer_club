require 'rails_helper'

RSpec.describe Computer, type: :model do
  it { should validate_presence_of :cost }
  it { should validate_presence_of :title }
  it { should validate_presence_of :creation }
end
