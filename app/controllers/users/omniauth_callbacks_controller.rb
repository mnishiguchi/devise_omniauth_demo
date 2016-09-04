class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook;      omniauth_callback; end
  def google_oauth2; omniauth_callback; end
  def twitter;       omniauth_callback; end

  private

    # Invoked after omniauth authentication is done.
    # This method can handle authentication for all the providers.
    # Alias this method as a provider name such as `twitter`, `facebook`, etc.
    def omniauth_callback

      # Obtain the authentication data.
      @auth = request.env["omniauth.auth"]
      provider_name = (@auth.provider == "google_oauth2") ? "Google" : @auth.provider.capitalize

      # Check if user is alreadly signed in.
      if user_signed_in?
        # Create a social profile from auth and ssociate that with current user.
        profile = SocialProfile.find_or_create_from_oauth(@auth)
        profile.associate_with_user(@current_user)
        flash[:success] = "Connected to #{provider_name}."
        redirect_to(edit_user_registration_url) and return
      end

      # Obtain user by auth data.
      @user = User.find_or_create_from_oauth(@auth)

      # Obtain user by email or create a new user.
      if @user.persisted? && @user.email_verified?
        sign_in @user
        flash[:success] = "Successfully authenticated from #{provider_name} account."
        redirect_to root_url
      else
        @user.reset_confirmation!
        flash[:warning] = "Please enter your email address to sign in or create an account on this app."
        redirect_to finish_signup_path(@user)
      end
    end
end
