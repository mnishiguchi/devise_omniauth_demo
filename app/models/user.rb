class User < ApplicationRecord
  # Configure Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :omniauthable
end
