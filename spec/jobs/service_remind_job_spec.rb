require 'rails_helper'

RSpec.describe ServiceRemindJob, type: :job do
  let(:computers) {create_list(:computer, 2)}
  let(:service) { double('Services::ServiceRemindJob') }

  before do
    allow(Services::ServiceRemind).to receive(:new).and_return(service)
  end

  it 'calls Services::ServiceRemindJob' do
    expect(service).to receive(:send_service_remind)
    ServiceRemindJob.perform_now
  end
end
