class Services::ServiceCheck
  def check_service
    Computer.all.each do |computer|
      computer.service_flag
    end
  end
end
