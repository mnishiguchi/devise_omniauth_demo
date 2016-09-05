# Destroy old data.
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
Client.create!(
  email:    "client@example.com",
  password: "password",
  confirmed_at: Time.zone.now
)

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
