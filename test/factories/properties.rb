# == Schema Information
#
# Table name: properties
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  client_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :property do
    name "A new apartmeint"
    description "nice"
    client
  end
end
