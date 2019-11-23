require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
" do
  background do
    visit root_path
    click_on 'Sign up', match: :first
  end

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'test@user'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_button 'Sign up'

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario 'Registered user tries to sign up' do
    user = create(:user)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'registered user tries to sign up with invalid input' do
    click_button 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
