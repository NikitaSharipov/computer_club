require 'rails_helper'

feature 'User can watch reservation', %q{
  In order to interact with reservations
  As an authenticated user
  I'd like to be able to watch my reservations
} do

  describe 'User' do

    given(:user) { create :user }
    given!(:computer) { create(:computer) }
    given!(:reservation) { create(:reservation, computer: computer, user: user) }

    background { sign_in(user) }

    scenario 'can delete reservation' do
      visit reservations_user_path(user)
      click_on 'Delete'
      expect(page).to have_content('You successfully delete reservation.')
    end

  end

end
