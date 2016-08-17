FactoryGirl.define do
  factory :client do
    sequence(:email)    { |n| "client_#{n}@example.com"}
    password            "password"
    confirmed_at        Time.now
  end
end
