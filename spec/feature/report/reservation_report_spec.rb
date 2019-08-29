require 'rails_helper'

feature 'Owner can watch reservation report', %q{
  In order to track the situation
  As an owner
  I'd like to watch report
} do

  given(:owner) { create :user, :owner  }

  background { sign_in(owner) }

  scenario "can watch reservation report" do
    visit owner_panel_path
    #click_on "Month report"
    #expect page to have revenue
    #expect page to have sum used hours
    #expect page to have sum unused hours
  end

end
