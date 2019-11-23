class Services::ServiceCheck
  def check_service
    Computer.all.each(&:service_flag)
  end
end
