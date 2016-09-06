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
    name: "Apartment #{i}",
    description: ('a'..'z').to_a.shuffle.join('')
  )
end

# AccountExecutive.
AccountExecutive.create!(
  email:    "ae@example.com",
  password: "longpassword"
)
# Administrator.
Administrator.create!(
  email:    "administrator@example.com",
  password: "longpassword"
)
# SuperUser.
SuperUser.create!(
  email:    "super_user@example.com",
  password: "longpassword"
)
