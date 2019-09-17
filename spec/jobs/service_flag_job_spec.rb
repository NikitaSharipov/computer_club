require 'rails_helper'

RSpec.describe ServiceFlagJob, type: :job do
  let(:computers) {create_list(:computer, 2)}
  let(:service) { double('Services::ServiceRemindJob') }


  before do
    allow(Services::ServiceCheck).to receive(:new).and_return(service)
  end

  it 'calls Services::ServiceCheck' do
    expect(service).to receive(:check_service)
    ServiceFlagJob.perform_now
  end
end
