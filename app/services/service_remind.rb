class Services::ServiceRemind
  def send_service_remind
    computers = Computer.where(service_needed: true)
    computers_titles = computers.pluck(:title)
    ServiceReminderMailer.remind(computers_titles).deliver_later
  end
end
