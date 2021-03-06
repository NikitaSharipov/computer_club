require 'rails_helper'

feature 'User can pay for a computer', "
  In order to use a computer
  As an authenticated user
  I'd like to be able to pay for a computer
" do
  given(:user) { create :user }
  given!(:computer) { create(:computer) }
  given!(:reservation) { create(:reservation, computer: computer, user: user) }

  background { sign_in(user) }

  scenario 'User can pay for computer' do
    visit payment_reservations_path
    click_on "Pay now!"
    expect(page).to have_content("Payment made")
  end

  scenario "User don't have enough credits" do
    user.credits = 1
    user.save
    visit payment_reservations_path
    click_on "Pay now!"
    expect(page).to have_content("Payment error")
  end

  scenario 'If user delete payed reservation, money returns' do
    credits = user.credits

    visit payment_reservations_path
    click_on "Pay now!"

    visit reservations_user_path(user)
    click_on 'Delete'
    expect(page).to have_content('You successfully delete reservation.')
    expect(page).to have_content("Your credits: #{credits}")
  end
end
