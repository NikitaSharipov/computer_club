require 'rails_helper'

feature 'User can interact with reservations', %q{
  As an authenticated user
  I'd like to be able to interact with my reservations
} do

  describe 'User' do

    given(:user) { create :user }
    given(:other) { create :user }
    given!(:computer) { create(:computer) }
    given!(:other_computer) { create(:computer) }
    given!(:reservation) { create(:reservation, computer: computer, user: user) }
    given!(:other_reservation) { create(:reservation, :other_reservation, computer: other_computer, user: other) }

    background { sign_in(user) }

    scenario 'can delete his reservation' do
      visit reservations_user_path(user)
      click_on 'Delete'
      expect(page).to have_content('You successfully delete reservation.')
    end

    scenario "can not see other user's reservations" do
      visit reservations_user_path(user)
      expect(page).to have_content(reservation.start_time.strftime("%d %B, %H:%M"))
      expect(page).to_not have_content(other_reservation.start_time.strftime("%d %B, %H:%M"))
    end
  end

end
