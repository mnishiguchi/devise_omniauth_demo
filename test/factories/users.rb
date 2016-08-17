FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "user_#{n}@example.com"}
    password            "password"
    confirmed_at        Time.now
  end
end
