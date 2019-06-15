require 'rails_helper'

feature 'User can book a computer', %q{
  In order to use a computer
  As an authenticated user
  I'd like to be able to book a computer
} do
  given(:user) { create :user }
  given!(:computer) { create(:computer) }

  background { sign_in(user) }

  describe 'User ' do
    given(:date_now) { Time.now }

    background do
      reservation = Reservation.create(start_time: date_now, end_time: date_now + 3600, user: user, computer: computer)
      visit reservation_computers_path
    end

    scenario 'sees current reservations on сertain date' do
      select((date_now).strftime("%B"), from: '_date_reservations_2i')
      select("#{date_now.day  }", from: "_date_reservations_3i")

      click_on 'Show'

      expect(page).to have_content("Reservations start time: #{(date_now - 10800).strftime("%d %B, %H:%M")}")
    end

    scenario "don't sees reservations on other date" do
      select((date_now).strftime("%B"), from: '_date_reservations_2i')
      select('11', from: "_date_reservations_3i")

      click_on 'Show'

      expect(page).to_not have_content("Reservations start time: #{(date_now - 10800).strftime("%d %B, %H:%M")}")
    end
  end

  scenario 'User tries to book a computer' do
    visit reservation_computers_path
    select(computer.title, from: 'computer_id')

    select('May', from: '_date_2i')
    select('30', from: "_date_3i")

    fill_in 'start_time', with: "15:00"
    fill_in 'duration', with: "1"

    click_on 'Make a reservation!'

    expect(page).to have_content('You reserved a computer.')
  end

  scenario 'Computer alredy reserved' do
    reservation = Reservation.create(start_time: "2019-5-30 15:00:00", end_time: "2019-5-30 16:00:00", user: user, computer: computer)

    visit reservation_computers_path
    select(computer.title, from: 'computer_id')

    select('May', from: '_date_2i')
    select('30', from: "_date_3i")

    fill_in 'start_time', with: "15:00"
    fill_in 'duration', with: "1"

    click_on 'Make a reservation!'

    expect(Reservation.count).to eq(1)
  end
end
