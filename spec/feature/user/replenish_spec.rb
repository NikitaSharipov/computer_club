require 'rails_helper'

feature 'User can replenish his account', %q{
  In order to pay for a computer
  As an authenticated user
  I'd like to be able to replenish my account
} do

  given(:user) { create :user }

  background { sign_in(user) }

  scenario 'user can replenish account' do
    click_on 'Replenish account'
    fill_in 'How many credits do you want to fund?', with: "100"
    click_on 'Replenish!'
    expect(page).to have_content('credits: 200')
  end

end
