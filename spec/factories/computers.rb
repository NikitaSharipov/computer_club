FactoryBot.define do
  sequence :title do |n|
    "computer#{n}"
  end

  factory :computer do
    title
    specifications { 'Hdd 1 tb'}
    cost { 10 }
    creation { DateTime.now - 1 }
  end
end
