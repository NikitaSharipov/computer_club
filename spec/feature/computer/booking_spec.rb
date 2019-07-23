require 'rails_helper'

feature 'User can book a computer', %q{
  In order to use a computer
  As an authenticated user
  I'd like to be able to book a computer
} do

  describe 'User' do

    given(:user) { create :user }
    given(:user2) { create :user }
    given!(:computer) { create(:computer) }

    background { sign_in(user) }

    describe 'reservations' do
      given(:date_now) { Time.now }

      background do
        reservation = Reservation.create(start_time: date_now, end_time: date_now + 3600, user: user, computer: computer)
        visit reservations_path
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
      visit reservations_path
      select(computer.title, from: 'computer_id')

      date = Date.today

      select("#{date.strftime("%B")}", from: '_date_2i')
      select("#{date.strftime("%-d")}", from: "_date_3i")

      fill_in 'start_time', with: "15:00"
      fill_in 'duration', with: "1"

      click_on 'Make a reservation!'

      expect(Reservation.count).to eq(1)

      expect(page).to have_content('You reserved a computer.')
    end

    scenario 'Computer alredy reserved' do
      reservation = Reservation.create(start_time: "2019-5-30 15:00:00", end_time: "2019-5-30 16:00:00", user: user, computer: computer)

      visit reservations_path
      select(computer.title, from: 'computer_id')

      select('May', from: '_date_2i')
      select('30', from: "_date_3i")

      fill_in 'start_time', with: "15:00"
      fill_in 'duration', with: "1"

      click_on 'Make a reservation!'

      expect(Reservation.count).to eq(1)
    end

    context "multiply questions", js: true do
      scenario "reservation appears on another user's page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit reservations_path
        end

        Capybara.using_session('guest') do
          sign_in(user2)
          visit reservations_path
        end

        Capybara.using_session('user') do
          select(computer.title, from: 'computer_id')

          select("#{Date.today.strftime("%B")}", from: '_date_2i')
          select("#{Date.today.strftime("%-d")}", from: "_date_3i")


          fill_in 'start_time', with: "15:00"
          fill_in 'duration', with: "1"

          click_on 'Make a reservation!'


          expect(page).to have_content 'You reserved a computer'
          expect(page).to have_content "Reservations start time: #{Date.today.strftime("%d")} #{Date.today.strftime("%B")}, 15:00"
        end

        Capybara.using_session('guest') do
          expect(page).to have_content "Reservations start time: #{Date.today.strftime("%d")} #{Date.today.strftime("%B")}, 15:00"
        end
      end
    end

  end

  describe 'Admin ' do

    given(:admin) { create :user, :admin  }
    given!(:computer) { create(:computer) }
    given(:date_now) { Time.now }

    background do
      sign_in(admin)
      visit admin_panel_path
    end

    scenario 'can reserve computer for user' do

      click_on "Reserve computer"

      select(admin.email, from: 'user_id')
      select(computer.title, from: 'computer_id')

      date = Date.today

      select("#{date.strftime("%B")}", from: '_date_2i')
      select("#{date.strftime("%-d")}", from: "_date_3i")

      fill_in 'start_time', with: "15:00"
      fill_in 'duration', with: "1"

      click_on 'Make a reservation!'

      expect(Reservation.count).to eq(1)

      expect(page).to have_content('You reserved a computer.')

    end

    scenario 'can remove reservation' do
      reservation = Reservation.create(start_time: date_now, end_time: date_now + 3600, user: admin, computer: computer)
      click_on "Reservations"
      click_on "Delete"
      expect(Reservation.count).to eq(0)
    end

    scenario 'can close debt' do
      reservation = Reservation.create(start_time: date_now, end_time: date_now + 3600, user: admin, computer: computer)
      click_on "Reservations"
      click_on "Close debt"
      expect(page).to have_content('Successful payment')
    end

  end


end
