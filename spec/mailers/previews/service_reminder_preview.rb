# Preview all emails at http://localhost:3000/rails/mailers/service_reminder
class ServiceReminderPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/service_reminder/remind
  def remind
    ServiceReminderMailer.remind
  end
end
