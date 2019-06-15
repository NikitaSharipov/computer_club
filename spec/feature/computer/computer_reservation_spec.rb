require 'rails_helper'

feature 'User can see reserved times', %q{
  In order to book a computer
  As an authenticated user
  I'd like to be able to see the time reserved on a specific date
} do
  given(:user) { create :user }
  given!(:computer) { create(:computer) }

  background { sign_in(user) }

    scenario 'User sees current reservations' do
    end
end
