module Liking
  def liked_by (user)
    likes.where(user: user).first_or_create
  end

  def liked_by? (user)
    likes.where(user: user).present?
  end
end
