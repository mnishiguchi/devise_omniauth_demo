# == Schema Information
#
# Table name: likes
#
#  id            :integer          not null, primary key
#  likeable_id   :integer
#  likeable_type :string
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

=begin
The Like model represents things that a User likes.
Users can like any likeable items.

Example:
  property = Property.first
  user.likes.create(likeable: property)
=end
class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user

  validates :likeable_id, presence: true
  validates :likeable_type, presence: true
end
