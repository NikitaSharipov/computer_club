require 'rails_helper'

feature 'User can log out', "
  In order to hide your data
  As an authenticated user
  I'd like to be able to log out
" do
  given(:user) { create(:user) }

  scenario 'authenticated user tries to sign out' do
    sign_in(user)
    click_on 'Log out'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
