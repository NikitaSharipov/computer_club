class ServiceReminderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.service_reminder_mailer.remind.subject
  #
  def remind(computers)
    @greeting = "Hi"
    @computers = computers

    mail to: "sharipovkzn@mail.ru"
  end
end
