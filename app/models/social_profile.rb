# == Schema Information
#
# Table name: social_profiles
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  provider    :string
#  uid         :string
#  name        :string
#  nickname    :string
#  email       :string
#  url         :string
#  image_url   :string
#  description :string
#  others      :text
#  credentials :text
#  raw_info    :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SocialProfile < ApplicationRecord
  belongs_to :user
  store      :others

  validates_uniqueness_of :uid, scope: :provider

  # Returns a SocialProfile object that corresponds to the specified data.
  def self.find_from_oauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider).tap do |profile|
      profile.save_oauth_data(auth)
    end
  end

  def save_oauth_data(auth)
    # Create params in correct format through a policy, then update the profile.
    self.update_attributes(policy(auth).params) if valid_oauth?(auth)
  end

  def associate_with_user(user)
    # NOTE: Profile user and the specified user must match.
    self.update!(user_id: user.id) unless self.user == user
  end

  private

    # Returns a policy object for the specified authentication data.
    def policy(auth)
      # Dynamically create an instance of appropriate policy.
      class_name = "#{auth['provider']}".classify
      "OAuthPolicy::#{class_name}".constantize.new(auth)
    end

    def valid_oauth?(auth)
      (self.provider.to_s == auth['provider'].to_s) && (self.uid == auth['uid'])
    end
end
