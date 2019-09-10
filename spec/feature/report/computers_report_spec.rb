require 'rails_helper'

feature 'Owner can watch computers report', %q{
  In order to track the situation
  As an owner
  I'd like to watch computers report
} do

  given(:owner) { create :user, :owner  }
  given(:date_tomorrow) { Date.tomorrow  }
  given(:date_today) { Date.today }

  background { sign_in(owner) }

  scenario "can create computers report" do
    visit owner_panel_path
    click_on 'Create report'
    fill_in 'Your report title', with: 'Title1'
  end

end
