require 'rails_helper'

feature 'Alministrator can add or delete computers', %q{
  In order to administrate
  As an administrator
  I'd like to be able to add or delete computers
} do

  given(:user) { create :user, :admin }
  given!(:computer) { create(:computer) }

  background { sign_in(user) }

  scenario 'Administrator can add computer' do
    visit computers_path
    click_on 'Add computer'
    fill_in 'title', with: "Test_title"
    fill_in 'specifications', with: "qwe"
    fill_in 'cost', with: 100
    fill_in 'creation', with: Time.now
    fill_in 'last_service', with: Time.now
    fill_in 'service_frequency', with: 2
    click_on 'Add'
    expect(page).to have_content('You have added a computer')
  end

  scenario 'Administrator can delete computer' do
    visit computers_path
    click_on 'Delete'
    expect(page).to have_content('You successfully delete computer.')
  end

end
