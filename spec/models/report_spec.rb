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
      expect(@report.computers.first.last).to eq(reservation1.duration_hours + reservation2.duration_hours )
    end
  end
end
