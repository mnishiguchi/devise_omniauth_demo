require 'active_support/concern'

# The Likeable module is a set of utility methods that is designed to
# be included into a Likeable model.
module Likeable
  extend ActiveSupport::Concern

  included do  # Instance methods

    def set_liked_by(user)
      likes.where(user: user).first_or_create
    end

    def set_unliked_by(user)
      like = likes.where(user: user).first
      like.destroy if like.present?
    end

    def liked_by?(user)
      likes.where(user: user).present?
    end

    def like_id_for(user)
      likes.where(user: user).ids.first
    end
  end

  class_methods do

    def find_all_liked_by(user)
      likes = Like.where("likeable_type=? AND user_id=?", name, user.id)
      likes.map { |like| name.constantize.find(like.likeable_id) }
    end
  end
end
