require 'rails_helper'

RSpec.describe Report, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :kind }

  describe 'after creations set fields' do
    let(:user) { create :user }
    let(:computer) { create(:computer) }

    let!(:reservation1) { create(:reservation, computer: computer, user: user, payed: true) }
    let!(:reservation2) { create(:reservation, :other_reservation, computer: computer, user: user, payed: true) }

    before { @report = Report.create(title: 'test', start_date: Date.yesterday, end_date: Date.tomorrow, user: user, kind: 'reservation') }

    it "should set sum proceeds to report.proceeds" do
      expect(@report.proceeds).to eq(reservation1.sum_pay(computer.cost) + reservation2.sum_pay(computer.cost))
    end

    it "should set sum rent_length to report.rent_length" do
      expect(@report.rent_length).to eq(reservation1.duration_hours + reservation2.duration_hours)
    end

    it "should set sum rent_length to report.rent_length" do
      sum_hours = (@report.end_date - @report.start_date).to_i * 24
      rent_length = reservation1.duration_hours + reservation2.duration_hours

      expect(@report.idle_length).to eq(sum_hours - rent_length)
    end

    it "should create hash of computers with sum reservations duration in value" do
      expect(@report.computers.first.first).to eq(computer)
      expect(@report.computers.first.last).to eq(reservation1.duration_hours + reservation2.duration_hours)
    end
  end

  describe 'reports with computers type' do
    let(:user) { create :user }

    it 'should return array of computers that will need service at a given interval' do
      Computer.create(title: 'computer1', cost: 10, creation: Time.now - 2.month, last_service: Time.now - 2.month, service_frequency: 1)
      computer2 = Computer.create(title: 'computer2', cost: 10, creation: Time.now - 2.month, last_service: Time.now - 29.day, service_frequency: 1)
      Computer.create(title: 'computer3', cost: 10, creation: Time.now - 2.month, last_service: Time.now + 2.month, service_frequency: 1)

      report = Report.create(title: 'test', start_date: Date.tomorrow, end_date: Date.tomorrow + 2.day, user: user, kind: 'computers')

      expect(report.service_needed).to eq([computer2])
    end
  end
end
