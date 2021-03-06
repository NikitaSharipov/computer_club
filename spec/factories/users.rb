FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    credits { 100 }
    password { '12345678' }
    password_confirmation { '12345678' }
    admin { false }
  end

  trait :low_credits do
    credits { 1 }
  end

  trait :admin do
    admin { true }
  end

  trait :owner do
    owner { true }
  end

  trait :old_user do
    created_at { Date.today - 1.year }
  end
end
