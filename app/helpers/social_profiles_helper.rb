module SocialProfilesHelper
  def formatted_provider_name(provider)
    (provider == "google_oauth2") ? "Google" : provider.capitalize
  end
end
