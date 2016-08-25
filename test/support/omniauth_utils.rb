# https://github.com/intridea/omniauth/wiki/Integration-Testing

# def set_invalid_omniauth
#   OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
# end

def set_omniauth_twitter
  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
    "provider" => "twitter",
    "uid"  => "mock_uid_1234567890",
    "info" => {
      "name"  => "Mock User",
      "image" => "http://mock_image_url.com",
      "urls"  => {
        "Website" => nil,
        "Twitter" => "https://twitter.com/MNishiguchiDC"
      }
    },
    "credentials" => {
       "token"  => "mock_credentials_token",
       "secret" => "mock_credentials_secret"
    },
    "extra" => {
      "raw_info" => {
        "name" => "Mock User",
        "id"   => "mock_uid_1234567890"
      }
    }
  })
end

def set_omniauth_facebook
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    "provider" => "facebook",
    "uid"  => "mock_uid_1234567890",
    "info" => {
      "name"  => "Mock User",
      "image" => "http://mock_image_url.com",
      "urls"  => {
        "Website" => nil,
        "Twitter" => "https://twitter.com/MNishiguchiDC"
      }
    },
    "credentials" => {
       "token"  => "mock_credentials_token",
       "secret" => "mock_credentials_secret"
    },
    "extra" => {
      "raw_info" => {
        "name" => "Mock User",
        "id"   => "mock_uid_1234567890"
      }
    }
  })
end

def set_omniauth_google_oauth2
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    "provider" => "google_oauth2",
    "uid"  => "mock_uid_1234567890",
    "info" => {
      "name"  => "Mock User",
      "image" => "http://mock_image_url.com",
      "urls"  => {
        "Website" => nil,
        "Twitter" => "https://twitter.com/MNishiguchiDC"
      }
    },
    "credentials" => {
       "token"  => "mock_credentials_token",
       "secret" => "mock_credentials_secret"
    },
    "extra" => {
      "raw_info" => {
        "name" => "Mock User",
        "id"   => "mock_uid_1234567890"
      }
    }
  })
end
