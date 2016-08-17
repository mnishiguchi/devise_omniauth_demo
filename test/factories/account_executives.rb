FactoryGirl.define do
  factory :account_executive do
    sequence(:email)    { |n| "ae_#{n}@example.com"}
    password            "password"
  end
end
