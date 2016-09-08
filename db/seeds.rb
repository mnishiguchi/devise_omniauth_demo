# Destroy old data.
Property.destroy_all
User.destroy_all
Client.destroy_all
Admin.destroy_all

# Create a user.
User.create!(
  email:    "user@example.com",
  password: "password",
  confirmed_at: Time.zone.now
)

# Create a client.
client = Client.create!(
  email:    "client@example.com",
  password: "password",
  confirmed_at: Time.zone.now
)

20.times do |i|
  client.properties.create!(
    name: "#{Faker::Name.last_name} Apartment",
    description: [
      Faker::Address.street_address,
      Faker::Address.city_prefix,
      Faker::Address.city_suffix,
      Faker::Address.state_abbr,
      Faker::Address.zip
    ].join(' ')
  )
end

# AccountExecutive.
AccountExecutive.create!(
  email:    "account-executive@example.com",
  password: "password"
)
# Administrator.
Administrator.create!(
  email:    "administrator@example.com",
  password: "password"
)
# SuperUser.
SuperUser.create!(
  email:    "super-user@example.com",
  password: "password"
)
