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

=begin
The Property model represents a property that a Client manages.
A User can like a Property.
=end
class Property < ApplicationRecord
  belongs_to :client
  has_many :likes, as: :likeable

  include Likeable

  scope :sorted, ->{ order(name: :asc) }
  scope :named, ->(q) { where("name ilike ?", "%#{q}%") }
end
