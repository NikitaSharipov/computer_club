require 'rails_helper'

feature 'User can see the list of computers', %q{
  In order to choose computer
  As an authenticated user
  I'd like to be able to see the list of computers
} do
  given(:user) { create :user }
  given!(:computer) { create(:computer) }
  given!(:computers) { create_list :computer, 3 }

  background { sign_in(user) }

  scenario 'User tries to see a computer list' do
    visit computers_path
    computers.each do |q|
      expect(page).to have_content q.title
    end
  end

  scenario 'User tries to see information about computer' do
    visit computers_path
    within(".computer_title#{computer.id}") { click_on 'Show' }
    expect(page).to have_content computer.title
    expect(page).to have_content computer.specifications
    expect(page).to have_content computer.cost
    expect(page).to have_content computer.creation
  end
end
