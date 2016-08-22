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

require 'test_helper'

class SocialProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
