class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook; omniauth_callback; end
  # def github; omniauth_callback; end
  def google_oauth2; omniauth_callback; end
  # def linkedin; omniauth_callback; end
  def twitter; omniauth_callback; end

  # Invoked after omniauth authentication is done.
  # This method can handle authentication for all the providers.
  # Alias this method as a provider name such as `twitter`, `facebook`, etc.
  def omniauth_callback

    # Obtain the authentication data.
    @auth = request.env["omniauth.auth"]

    # Ensure that the authentication data exists.
    unless @auth.present?
      flash[:danger] = "Authentication data was not provided"
      redirect_to root_url and return
    end

    # Obtain the provider name from the callee.
    provider = __callee__.to_s

    # If user was not found, search by email or create a new user.
    @user = User.find_or_create_from_oauth(@auth)

    if @user.persisted? && @user.email_verified?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
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
