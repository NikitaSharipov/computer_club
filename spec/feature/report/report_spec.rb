require 'rails_helper'

feature 'Owner can watch computers report', %q{
  In order to track the situation
  As an owner
  I'd like to watch computers report
} do

  given(:owner) { create :user, :owner  }
  given(:date_tomorrow) { Date.tomorrow  }
  given(:date_today) { Date.today }
  given!(:report) {create(:report, title: 'test', start_date: Date.tomorrow, end_date: Date.tomorrow + 2.day, user: owner, kind: 'computers') }


  background { sign_in(owner) }

  scenario "can create report" do
    visit owner_panel_path
    click_on 'Create report'

    select("computers", from: "kind")
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

  scenario "can delete report" do
    visit owner_panel_path
    click_on 'Watch existing reports'
    click_on 'Delete'

    expect(page).to have_content('You successfully delete report.')
  end

  scenario "can not create any report with wrong date" do
    visit owner_panel_path
    click_on 'Create report'

    select("computers", from: "kind")
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

  scenario "can watch all reports" do
    visit owner_panel_path
    click_on 'Watch existing reports'
    expect(page).to have_content("#{report.title}")
  end

  describe "computers report" do
    scenario "can watch report with 0 computers that needs service maintenance" do
      visit reports_path
      click_on 'Show'
      expect(page).to have_content("There are no computers needing maintenance at a given time interval")
    end

    scenario "can watch report and it's fields with computer that need maintenance" do
      computer1 = Computer.create(title: 'computer1', cost: 10, creation: Time.now - 2.month, last_service: Time.now - 2.month, service_frequency: 1)
      computer2 = Computer.create(title: 'computer2', cost: 10, creation: Time.now - 2.month, last_service: Time.now - 29.day, service_frequency: 1)
      computer3 = Computer.create(title: 'computer3', cost: 10, creation: Time.now - 2.month, last_service: Time.now + 2.month, service_frequency: 1)

      visit reports_path
      click_on 'Show'
      expect(page).to have_content("Service needed computers only for this date range is\n#{computer2.title}")
    end
  end

  describe "reservation report" do

    given(:computer1) { create(:computer) }
    given(:computer2) { create(:computer) }
    given!(:reservation1) { create(:reservation, computer: computer1, user: owner, payed: true) }
    given!(:reservation2) { create(:reservation, :other_reservation, computer: computer2, user: owner, payed: true) }
    given!(:report_new) {create(:report, title: 'report_new', start_date: Date.yesterday, end_date: Date.tomorrow, user: owner) }

    scenario "can watch 1 report and it's fields" do
      visit reports_path
      within(".report_title#{report_new.id}") do
        click_on 'Show'
      end
      expect(page).to have_content("#{report_new.title}")
      expect(page).to have_content("#{report_new.start_date}")
      expect(page).to have_content("#{report_new.end_date}")
      expect(page).to have_content("#{report_new.proceeds}")
      expect(page).to have_content("#{report_new.rent_length}")
      expect(page).to have_content("#{report_new.idle_length}")
      expect(page).to have_content("Rent length for #{report_new.computers.first.first.title} is #{report_new.computers.first.last} hour(s)")
    end
  end

  describe "users report" do
    given(:old_user) { create :user, :old_user  }
    given!(:report_new) {create(:report, title: 'report_new', start_date: Date.yesterday, end_date: Date.tomorrow, user: owner, kind: 'users') }

    scenario "can watch 1 report and it's fields" do

    visit reports_path

    within(".report_title#{report_new.id}") do
      click_on 'Show'
    end

    expect(page).to have_content("#{owner.email}")
    expect(page).to have_content("user's credits: #{owner.credits}")
    expect(page).to_not have_content("#{old_user.email}")
    end
  end

end
