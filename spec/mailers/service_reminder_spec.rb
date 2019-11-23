require "rails_helper"

RSpec.describe ServiceReminderMailer, type: :mailer do
  describe "remind" do
    let(:computers) { create_list(:computer, 2) }
    let(:mail) { ServiceReminderMailer.remind(computers) }

    it "renders the headers" do
      expect(mail.subject).to eq("Remind")
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
