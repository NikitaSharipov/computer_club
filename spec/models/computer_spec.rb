require 'rails_helper'

RSpec.describe Computer, type: :model do
  it { should validate_presence_of :cost }
  it { should validate_presence_of :title }
  it { should validate_presence_of :creation }

  describe 'service flag' do
    let(:computer) { create(:computer) }

    it 'should set last service if self.last_service == nil' do
      computer.service_flag
      expect(computer.last_service).to eq(computer.creation)
    end

    it 'should set service needed to true if service time has come' do
      computer1 = Computer.create(title: 'computer', cost: 10, creation: Time.now - 2.month, service_frequency: 1)
      computer1.service_flag
      expect(computer1.service_needed).to eq(true)
    end

    it 'should set service needed to true if service time will come to given date' do
      computer2 = Computer.create(title: 'test', cost: 10, creation: Time.now - 20.days, service_frequency: 1)
      computer2.service_flag_temporary(Time.now + 1.month)
      expect(computer2.service_needed).to eq(true)
    end
  end
end
