# This module provides utitity classes to format params for creating a social
# profile record based on the result of OAuth authentication.
# NOTE: The subclass names must match provider names.
module OAuthPolicy
  class Base
    def params
      {
        uid:         @uid,
        name:        @name,
        nickname:    @nickname,
        email:       @email,
        url:         @url,
        image_url:   @image_url,
        description: @description,
        credentials: @credentials,
        raw_info:    @raw_info
      }
    end
  end

  class Facebook < OAuthPolicy::Base
    def initialize(auth)
      info = auth['info']
      @provider    = auth["provider"]
      @uid         = auth["uid"]
      @name        = info["name"]
      @nickname    = ""
      @email       = info["email"]
      @url         = "https://www.facebook.com/#{@uid}"
      @image_url   = info["image"]
      @description = ""
      @credentials = auth["credentials"].to_json
      @raw_info    = auth["extra"]["raw_info"].to_json
      freeze
    end
  end

  class GoogleOauth2 < OAuthPolicy::Base
    def initialize(auth)
      info = auth['info']
      @provider    = auth["provider"]
      @uid         = auth["uid"]
      @name        = info["name"]
      @nickname    = ""
      @email       = info["email"]
      @url         = "https://plus.google.com/"
      @image_url   = info["image"]
      @description = ""
      @credentials = auth["credentials"].to_json
      @raw_info    = auth["extra"]["raw_info"].to_json
      freeze
    end
  end

  class Twitter < OAuthPolicy::Base
    def initialize(auth)
      info = auth['info']
      @provider    = auth["provider"]
      @uid         = auth["uid"]
      @name        = info["name"]
      @nickname    = info["nickname"]
      @email       = ""
      @url         = info["urls"]["Twitter"]
      @image_url   = info["image"]
      @description = info["description"].try(:truncate, 255)
      @credentials = auth["credentials"].to_json
      @raw_info    = auth["extra"]["raw_info"].to_json
      freeze
    end
  end
end
