FactoryBot.define do
  factory :reservation do
    start_time { Time.now }
    end_time { Time.now + 3600 }
  end

  trait :other_reservation do
    start_time { Time.now + 7200 }
    end_time { Time.now + 10800 }
  end
end
