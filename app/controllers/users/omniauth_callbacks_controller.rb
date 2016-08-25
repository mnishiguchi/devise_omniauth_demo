class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    omniauth_callback;
  end
  # def github; omniauth_callback; end
  def google_oauth2
    omniauth_callback;
  end
  # def linkedin; omniauth_callback; end
  def twitter
    omniauth_callback;
  end

  private

    # Invoked after omniauth authentication is done.
    # This method can handle authentication for all the providers.
    # Alias this method as a provider name such as `twitter`, `facebook`, etc.
    def omniauth_callback

      # Obtain the authentication data.
      @auth = request.env["omniauth.auth"]
      provider_name = @auth.provider == "google_oauth2" ? "Google" : @auth.provider.capitalize

      # Ensure that the authentication data exists.
      unless @auth.present?
        flash[:danger] = "Authentication data was not provided"
        redirect_to root_url and return
      end

      # Check if user is alreadly signed in.
      if user_signed_in?
        # Create a social profile from auth and ssociate that with current user.
        profile = SocialProfile.find_or_create_from_oauth(@auth)
        profile.associate_with_user(@current_user)
        flash[:success] = "Connected to #{provider_name}."
        redirect_to root_url
        return
      end

      # If user was not found, search by email or create a new user.
      @user = User.find_or_create_from_oauth(@auth)

      if @user.persisted? && @user.email_verified?
        sign_in_and_redirect @user, event: :authentication
        if is_navigational_format?
          set_flash_message(:notice, :success, kind: provider_name)
        end
      else
        @user.reset_confirmation!
        flash[:warning] = "Please enter your email address to sign in or create an account on this app."
        redirect_to finish_signup_path(@user)
      end
    end
end

# You should configure your model like this:
# devise :omniauthable, omniauth_providers: [:twitter]

# You should also create an action method in this controller like this:
# def twitter
# end

# More info at:
# https://github.com/plataformatec/devise#omniauth

# GET|POST /resource/auth/twitter
# def passthru
#   super
# end

# GET|POST /users/auth/twitter/callback
# def failure
#   super
# end

# protected

# The path used when OmniAuth fails
# def after_omniauth_failure_path_for(scope)
#   super(scope)
# end
