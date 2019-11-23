FactoryBot.define do
  factory :report do
    title
    start_date { Date.yesterday }
    end_date { Date.tomorrow }
    kind { 'reservation' }
  end
end
