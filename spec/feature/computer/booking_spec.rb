require 'rails_helper'

feature 'User can request a software installation', %q{
  In order to User a computer
  As an authenticated user
  I'd like to be able to book a computer
} do

  given(:user) { create :user }
  given!(:computer) { create(:computer) }

  background { sign_in(user) }

  scenario 'User tries to book a computer' do
    visit computer_book_path

  end

end
