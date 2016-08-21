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

  # TODO
  class GoogleOauth2 < OAuthPolicy::Base
    def initialize(auth)
      info = auth['info']
      @provider    = auth["provider"]
      @uid         = auth["uid"]
      @name        = info["name"]
      @nickname    = ""
      @email       = ""
      @url         = info["urls"]
      @image_url   = info["image"]
      @description = info["description"].try(:truncate, 255)
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

  # class Facebook < OAuthPolicy::Base
  #   def initialize(auth)
  #     info = auth['info']
  #     @provider    = auth["provider"]
  #     @uid         = auth["uid"]
  #     @name        = info["name"]
  #     @nickname    = ""
  #     @email       = ""
  #     @url         = "https://www.facebook.com/"
  #     @image_url   = info["image"]
  #     @description = ""
  #     @credentials = auth["credentials"].to_json
  #     @raw_info    = auth["extra"]["raw_info"].to_json
  #     freeze
  #   end
  # end
end
