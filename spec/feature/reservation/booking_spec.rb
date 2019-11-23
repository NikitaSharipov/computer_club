require 'rails_helper'

feature 'User can book a computer', %q{
  In order to use a computer
  As an authenticated user
  I'd like to be able to book a computer
} do

  given!(:computer) { create(:computer) }

  describe 'User' do

    given(:user) { create :user }
    given(:user2) { create :user }

    background { sign_in(user) }

    describe 'reservations' do
      given(:date_now) { Time.zone.now }

      background do
        reservation = Reservation.create(start_time: date_now, end_time: date_now + 3600, user: user, computer: computer)
        visit reservations_path
      end

      scenario 'sees current reservations on сertain date' do
        date_tomorrow = date_now + 1.day
        reservation = Reservation.create(start_time: date_tomorrow, end_time: date_tomorrow + 3600, user: user, computer: computer)

        fill_in 'date_reservations', with: Date.tomorrow

        click_on 'Show'

        expect(page).to have_content("Reservations start time: #{(date_tomorrow).strftime("%d %B, %H:%M")}")
      end

      scenario 'sees current reservations on today' do
        expect(page).to have_content("Reservations start time: #{(date_now).strftime("%d %B, %H:%M")}")
      end

      scenario "don't sees reservations on other date" do

        fill_in 'date_reservations', with: Date.tomorrow

        click_on 'Show'

        expect(page).to_not have_content("Reservations start time: #{(date_now).strftime("%d %B, %H:%M")}")
      end
    end

    scenario 'User tries to book a computer' do
      visit reservations_path
      select(computer.title, from: 'computer_id')

      fill_in 'date', with: Date.today

      fill_in 'start_time', with: "15:00"
      fill_in 'duration', with: "1"

      click_on 'Make a reservation!'

      expect(page).to have_content('You reserved a computer.')
    end

    scenario 'Computer alredy reserved' do
      start_time = Time.zone.now
      reservation = Reservation.create(start_time: start_time , end_time: start_time + 3600, user: user, computer: computer)

      visit reservations_path
      select(computer.title, from: 'computer_id')

      fill_in 'date', with: Date.today

      fill_in 'start_time', with: "#{start_time.strftime("%H:%M")}"
      fill_in 'duration', with: "1"

      click_on 'Make a reservation!'

      expect(page).to have_content('reservation time intersection')
    end


    # context "multiply reservations", js: true do
    #   scenario "reservation appears on another user's page" do
    #     Capybara.using_session('user') do
    #       sign_in(user)
    #       visit reservations_path
    #     end

    #     Capybara.using_session('guest') do
    #       sign_in(user2)
    #       visit reservations_path
    #     end

    #     Capybara.using_session('user') do
    #       select(computer.title, from: 'computer_id')

    #       select("#{Date.today.strftime("%B")}", from: '_date_2i')
    #       select("#{Date.today.strftime("%-d")}", from: "_date_3i")


    #       fill_in 'start_time', with: "15:00"
    #       fill_in 'duration', with: "1"

    #       click_on 'Make a reservation!'


    #       expect(page).to have_content 'You reserved a computer'
    #       expect(page).to have_content "Reservations start time: #{Date.today.strftime("%d")} #{Date.today.strftime("%B")}, 15:00"
    #     end

    #     Capybara.using_session('guest') do
    #       expect(page).to have_content "Reservations start time: #{Date.today.strftime("%d")} #{Date.today.strftime("%B")}, 15:00"
    #     end
    #   end
    # end

  end

  describe 'Admin ' do

    given(:admin) { create :user, :admin  }
    given(:date_now) { Time.zone.now }

    background do
      sign_in(admin)
      visit admin_panel_path
    end

    scenario 'can reserve computer for user' do

      click_on "Reserve computer"

      select(admin.email, from: 'user_id')
      select(computer.title, from: 'computer_id')

      fill_in 'date', with: Date.today

      fill_in 'start_time', with: "15:00"
      fill_in 'duration', with: "1"

      click_on 'Make a reservation!'

      expect(page).to have_content('You reserved a computer.')

    end

    scenario 'can not reserve computer for user with time intersection' do
      start_time = Time.zone.now
      reservation = Reservation.create(start_time: start_time , end_time: start_time + 3600, user: admin, computer: computer)

      visit reservations_path
      select(admin.email, from: 'user_id')
      select(computer.title, from: 'computer_id')

      fill_in 'date', with: Date.today

      fill_in 'start_time', with: "#{start_time.strftime("%H:%M")}"
      fill_in 'duration', with: "1"

      click_on 'Make a reservation!'

      expect(page).to have_content('reservation time intersection')
    end

    scenario 'can remove reservation' do
      reservation = Reservation.create(start_time: date_now, end_time: date_now + 3600, user: admin, computer: computer)
      click_on "Reservations"
      click_on "Delete"
      expect(page).to have_content('You successfully delete reservation.')
    end

    scenario 'can close debt' do
      reservation = Reservation.create(start_time: date_now, end_time: date_now + 3600, user: admin, computer: computer)
      click_on "Reservations"
      click_on "Close debt"
      expect(page).to have_content('Successful payment')
    end

  end


end
