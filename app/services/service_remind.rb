class Services::ServiceRemind
  def send_service_remind
    computers = Computer.where(service_needed: true)
    computers_titles = computers.pluck(:title)
    ServiceReminderMailer.remind(computers_titles).deliver_later
  end
end




#  created-at 9 month ago
#  last_service nill
#  service_frequency 9 month

#  1 last_service + service_frequency > now
#  2 last_service - nill< creation + service_frequency > now
