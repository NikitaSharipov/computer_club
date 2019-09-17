class ServiceFlagJob < ApplicationJob
  queue_as :default

  def perform
    Services::ServiceCheck.new.check_service
  end
end
