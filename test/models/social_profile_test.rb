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

describe SocialProfile do

  before do
    @social_profile = create(:social_profile)
  end

  it "should be valid" do
    assert @social_profile.valid?
    assert belong_to :user
    assert validate_uniqueness_of :uid
    # NOTE: Actually uniqueness of uid is enforced with scope: :provider,
    # but we cannot test the use of scoped uniqueness.
  end

end
