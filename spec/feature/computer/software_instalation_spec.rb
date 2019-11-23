require 'rails_helper'

feature 'User can request a software installation', "
  In order to use necessary programm
  As an authenticated user
  I'd like to be able to leave a request for installation
" do
  given(:user) { create :user }
  given!(:computer) { create(:computer) }

  background { sign_in(user) }

  scenario 'User tries leave a request for installation' do
    visit computer_path(computer)
    click_on 'Leave a request for software instalation'
    fill_in 'Software title', with: 'Software 1'
    fill_in 'Url for downloading', with: 'www.google.com'
    click_on 'Send request!'
    expect(page).to have_content 'Your request successfully sent'
  end
end
