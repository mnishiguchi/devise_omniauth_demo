# == Schema Information
#
# Table name: account_executives
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'test_helper'

# class AccountExecutiveTest < ActiveSupport::TestCase
#
#   def setup
#     @account_executive = create(:account_executive)
#   end
#
#   test "should be valid" do
#     assert @account_executive.valid?
#   end
# end
