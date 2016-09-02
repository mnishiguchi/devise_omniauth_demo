# http://www.rubydoc.info/github/plataformatec/devise/Devise/RegistrationsController
class Users::RegistrationsController < Devise::RegistrationsController

  # # GET /resource/sign_up
  # def new
  #   build_resource({})
  #   redirect_to "users/sign_up"
  # end
  #
  # # POST /resource
  # def create
  #   if user = User.find_by(email: params[:user][:email].downcase)
  #     user.update_columns(confirmed_at: nil)
  #     user.send_confirmation_instructions
  #     flash[:info] = "We sent a link to sign in. Please check your inbox."
  #     redirect_to root_url
  #   else
  #     super
  #   end
  # end

  protected

    # def build_resource(hash=nil)
    #   # Intercept the hash and add random password to it so that user can be
    #   # saved without passing a password from the form.
    #   hash[:password] = hash[:password_confirmation] = Devise.friendly_token[0,20]
    #   super
    # end

    def update_resource(resource, params)
      resource.update_without_password(params)
    end
end
