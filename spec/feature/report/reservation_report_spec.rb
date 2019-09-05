require 'rails_helper'

feature 'Owner can watch reservation report', %q{
  In order to track the situation
  As an owner
  I'd like to watch report
} do

  given(:owner) { create :user, :owner  }
  given(:date_tomorrow) { Date.tomorrow  }
  given(:date_today) { Date.today }

  background { sign_in(owner) }

  scenario "can create reservation report" do
    visit owner_panel_path
    click_on 'Create report'
    fill_in 'Your report title', with: 'Title1'

    select("#{date_today.year}", from: "_start_date_1i")
    select("#{date_today.strftime("%B")}", from: "_start_date_2i")
    select("#{date_today.day}", from: "_start_date_3i")

    select("#{date_tomorrow.year}", from: "_end_date_1i")
    select("#{date_tomorrow.strftime("%B")}", from: "_end_date_2i")
    select("#{date_tomorrow.day}", from: "_end_date_3i")

    click_on 'Create report'

    expect(page).to have_content('You created a report')
  end

  scenario "can not create reservation report with wrong date" do
    visit owner_panel_path
    click_on 'Create report'
    fill_in 'Your report title', with: 'Title1'

    select("#{date_today.year}", from: "_end_date_1i")
    select("#{date_today.strftime("%B")}", from: "_end_date_2i")
    select("#{date_today.day}", from: "_end_date_3i")

    select("#{date_tomorrow.year}", from: "_start_date_1i")
    select("#{date_tomorrow.strftime("%B")}", from: "_start_date_2i")
    select("#{date_tomorrow.day}", from: "_start_date_3i")

    click_on 'Create report'

    expect(page).to have_content('start time can not be more than the end time')
  end

  describe "report" do

    given(:computer) { create(:computer) }
    given!(:reservation1) { create(:reservation, computer: computer, user: owner, payed: true) }
    given!(:reservation2) { create(:reservation, :other_reservation, computer: computer, user: owner, payed: true) }
    given!(:report) {create(:report, title: 'test', start_date: Date.yesterday, end_date: Date.tomorrow, user: owner) }

    scenario "can watch all reports" do
      visit owner_panel_path
      click_on 'Watch existing reports'
      expect(page).to have_content("#{report.title}")
      #click_on "#{report.title}"
      # expect(page).to have_content('start time can not be more than the end time')
    end

    scenario "can watch 1 report and it's fields" do
      visit reports_path
      click_on 'Show'
      expect(page).to have_content("#{report.title}")
      expect(page).to have_content("#{report.start_date}")
      expect(page).to have_content("#{report.end_date}")
      expect(page).to have_content("#{report.proceeds}")
      expect(page).to have_content("#{report.rent_length}")
      expect(page).to have_content("#{report.idle_length}")
    end
  end

end

