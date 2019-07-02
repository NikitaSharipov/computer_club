class ServiceRemindJob < ApplicationJob
  queue_as :default

  def perform
    Services::ServiceRemind.new.send_service_remind
  end
end
