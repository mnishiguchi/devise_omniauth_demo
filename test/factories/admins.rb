FactoryGirl.define do
  factory :admin do
    sequence(:email)    { |n| "admin_#{n}@example.com"}
    password            "password"
  end
end
