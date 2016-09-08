module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title="")
    base_title = "Apartment showoff"

    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  # Stores the URL that a user wants to access.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Returns the Gravatar image tag for the given user.
  def gravatar_for(user, options = { size: 80 })
    # Standardize on all lower-case addresses
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.email, class: "gravatar")
  end

  # Returns an image tag for the given user with one of his/her
  # social profile image if any.
  def social_image_for(user, options = { size: 80 })
    image_urls = user.social_profiles.pluck(:image_url)
    border = 4
    unless image_urls.empty?
      image_tag(image_urls.sample, size: options[:size] + border,
        alt: user.email, class: "gravatar")
    end
  end
end
