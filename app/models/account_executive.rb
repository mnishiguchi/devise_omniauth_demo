class AccountExecutive < ApplicationRecord
  # Configure Devise modules
  devise :database_authenticatable, :trackable, :validatable
end
