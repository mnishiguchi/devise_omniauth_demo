module SocialProfilesHelper

  def formatted_provider_name(provider)
    (provider == "google_oauth2") ? "Google" : provider.capitalize
  end

  # Returns an image tag for the given user with one of his/her
  # social profile image if any.
  def social_profile_image(profile, options = { size: 80 })
    return if profile.nil?
    image_tag(profile.image_url, size: options[:size], alt: profile.user.email)
  end
end
