require 'rails_helper'

feature 'Owner can watch computers report', "
  In order to track the situation
  As an owner
  I'd like to watch computers report
" do
  given(:owner) { create :user, :owner }
  given(:date_tomorrow) { Date.tomorrow }
  given(:date_today) { Date.today }
  given!(:report) { create(:report, title: 'test', start_date: Date.tomorrow, end_date: Date.tomorrow + 2.day, user: owner, kind: 'computers') }

  background { sign_in(owner) }

  scenario "can create report" do
    visit owner_panel_path
    click_on 'Create report'

    select("computers", from: "kind")
    fill_in 'Your report title', with: 'Title1'

    fill_in 'start_date', with: Date.today

    fill_in 'end_date', with: Date.tomorrow

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

    fill_in 'start_date', with: Date.tomorrow

    fill_in 'end_date', with: Date.today

    click_on 'Create report'

    expect(page).to have_content('start time can not be more than the end time')
  end

  scenario "can watch all reports" do
    visit owner_panel_path
    click_on 'Watch existing reports'
    expect(page).to have_content(report.title.to_s)
  end

  describe "computers report" do
    scenario "can watch report with 0 computers that needs service maintenance" do
      visit reports_path
      click_on 'Show'
      expect(page).to have_content("There are no computers needing maintenance at a given time interval")
    end

    scenario "can watch report and it's fields with computer that need maintenance" do
      Computer.create(title: 'computer1', cost: 10, creation: Time.now - 2.month, last_service: Time.now - 2.month, service_frequency: 1)
      computer = Computer.create(title: 'computer2', cost: 10, creation: Time.now - 2.month, last_service: Time.now - 29.day, service_frequency: 1)
      Computer.create(title: 'computer3', cost: 10, creation: Time.now - 2.month, last_service: Time.now + 2.month, service_frequency: 1)

      visit reports_path
      click_on 'Show'
      expect(page).to have_content("Service needed computers only for this date range is\n#{computer.title}")
    end
  end

  describe "reservation report" do
    given(:computer1) { create(:computer) }
    given(:computer2) { create(:computer) }
    given!(:reservation1) { create(:reservation, computer: computer1, user: owner, payed: true) }
    given!(:reservation2) { create(:reservation, :other_reservation, computer: computer2, user: owner, payed: true) }
    given!(:report_new) { create(:report, title: 'report_new', start_date: Date.yesterday, end_date: Date.tomorrow, user: owner) }

    scenario "can watch 1 report and it's fields" do
      visit reports_path
      within(".report_title#{report_new.id}") do
        click_on 'Show'
      end
      expect(page).to have_content(report_new.title.to_s)
      expect(page).to have_content(report_new.start_date.to_s)
      expect(page).to have_content(report_new.end_date.to_s)
      expect(page).to have_content(report_new.proceeds.to_s)
      expect(page).to have_content(report_new.rent_length.to_s)
      expect(page).to have_content(report_new.idle_length.to_s)
      expect(page).to have_content("Rent length for #{report_new.computers.first.first.title} is #{report_new.computers.first.last} hour(s)")
    end
  end

  describe "users report" do
    given(:old_user) { create :user, :old_user }
    given!(:report_new) { create(:report, title: 'report_new', start_date: Date.yesterday, end_date: Date.tomorrow, user: owner, kind: 'users') }

    scenario "can watch 1 report and it's fields" do
      visit reports_path

      within(".report_title#{report_new.id}") do
        click_on 'Show'
      end

      expect(page).to have_content(owner.email.to_s)
      expect(page).to have_content("user's credits: #{owner.credits}")
      expect(page).to_not have_content(old_user.email.to_s)
    end
  end
end
