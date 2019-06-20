FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    credits { 100 }
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  trait :low_credits do
    credits { 1 }
  end
end
