class ServiceReminderMailer < ApplicationMailer
  def remind(computers)
    @greeting = "Hi"
    @computers = computers

    mail to: "sharipovkzn@mail.ru"
  end
end
