require 'rails_helper'

RSpec.describe Reservation, type: :model do

  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }

  it { should belong_to(:computer) }
  it { should belong_to(:user) }

  describe 'custom validations' do

    let!(:user) { create(:user) }
    let!(:computer) { create(:computer) }

    it "raises an error if end time is lower than start time" do
      invalid_reservation = Reservation.new(start_time: "2018-10-05 10:00:00", end_time: "2018-10-05 09:00:00", user: user, computer: computer)
      invalid_reservation.valid?
      expect(invalid_reservation.errors.full_messages).to include("start time can not be more than the end time")
    end

    it "raises an error if find time intersection" do
      reservation = Reservation.create(start_time: "2018-10-05 9:00:00", end_time: "2018-10-05 10:00:00", user: user, computer: computer)
      invalid_reservation = Reservation.new(start_time: "2018-10-05 9:30:00", end_time: "2018-10-05 10:00:00", user: user, computer: computer)
      invalid_reservation.valid?
      expect(invalid_reservation.errors.full_messages).to include("reservation time intersection")
    end

    it "create reservation if there is no time intersection" do
      reservation = Reservation.create(start_time: "2018-10-05 9:00:00", end_time: "2018-10-05 10:00:00", user: user, computer: computer)
      invalid_reservation = Reservation.new(start_time: "2018-10-05 10:00:00", end_time: "2018-10-05 11:00:00", user: user, computer: computer)
      invalid_reservation.valid?
      expect(invalid_reservation.valid?).to be true
    end

  end

end
