FactoryBot.define do
  factory :reservation do
    start_time { Time.now }
    end_time { Time.now + 3600 }
  end
end
