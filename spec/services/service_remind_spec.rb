require 'rails_helper'

RSpec.describe Services::ServiceRemind do
  it 'sends mail to owner' do
    expect(ServiceReminderMailer).to receive(:remind).and_call_original
    subject.send_service_remind
  end
end
