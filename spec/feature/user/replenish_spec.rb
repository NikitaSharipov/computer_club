require 'rails_helper'

feature 'User can replenish account', %q{
  In order to pay for a computer
  As an authenticated user
  I'd like to be able to replenish my account
} do

  describe 'User' do

    given(:user) { create :user }

    background { sign_in(user) }

    scenario 'can replenish account' do
      click_on 'Replenish account'
      fill_in 'How many credits do you want to fund?', with: "100"
      click_on 'Replenish!'
      expect(page).to have_content('credits: 200')
    end

  end

  describe 'Admin' do

    given(:admin) { create :user, :admin  }

    background { sign_in(admin) }

    scenario "can replenish user's account" do
      visit admin_panel_path
      click_on "Replenish user's account"
      select(admin.email, from: 'user_id')
      fill_in 'How many credits do you want to fund?', with: "100"
      click_on 'Replenish!'
      expect(page).to have_content('credits: 200')
    end

  end

end
