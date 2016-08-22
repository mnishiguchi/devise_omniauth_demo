# http://www.rubydoc.info/github/plataformatec/devise/Devise/RegistrationsController
class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    build_resource({})
    respond_with resource, location: "users/sign_up"
  end

  # POST /resource
  def create
    if user = User.find_by(email: params[:user][:email].downcase)
      user.update_columns(confirmed_at: nil)
      user.send_confirmation_instructions
      flash[:info] = "We sent a link to sign in. Please check your inbox."
      respond_with resource, location: root_url
    else
      super
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

    def build_resource(hash=nil)
      # Intercept the hash and add random password to it so that user can be
      # saved without passing a password from the form.
      hash[:password] = hash[:password_confirmation] = Devise.friendly_token[0,20]
      super
    end

    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    # end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
end
