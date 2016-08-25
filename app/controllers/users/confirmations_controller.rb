# http://www.rubydoc.info/github/plataformatec/devise/Devise/RegistrationsController
class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      sign_in(@user)
      respond_with_navigational(resource) do
        redirect_to after_confirmation_path_for(resource_name, resource)
      end
    elsif already_confirmed?
      # If the only error is that user is already confirmed, just log him/her in.
      set_flash_message(:notice, :confirmed) if is_flashing_format?
      sign_in(@user)
      respond_with_navigational(resource) do
        redirect_to after_confirmation_path_for(resource_name, resource)
      end
    elsif email_exists?
      # If the same email is in the database and the old user account has no
      # social profiles associated with it, sign in the user with new account and
      # archive the old one by marking its email.
      email = @user.email

      # Check if there is a user registered with the same email in the database
      # because email duplication is restricted.
      # We will keep the new one and archive the old one.
      if (old_user = User.find_by email: email)
        if old_user.social_profiles.empty?
          old_user.archive!
        else
          @user.merge_social_profiles(old_user) && old_user.archive!
        end

        # Set the total sign in count on the user.
        total_sign_in_count = @user.sign_in_count + old_user.sign_in_count
        @user.update_column(:sign_in_count, total_sign_in_count)
      end

      set_flash_message(:notice, :confirmed) if is_flashing_format?
      sign_in(@user)
      respond_with_navigational(resource) do
        redirect_to after_confirmation_path_for(resource_name, resource)
      end
    else
      # If there are other errors, we need to confirm the user's email again.
      respond_with_navigational(resource) do
        flash[:danger] = "Error confirming email. Please sign in again."
        redirect_to root_url
      end
    end
  end

  private

    def email_exists?
      regex = /has already been taken/
      messages = resource.errors.messages
      (messages.size == 1) && regex.match(messages[:email].first)
    end

    def already_confirmed?
      regex = /was already confirmed/
      messages = resource.errors.messages
      (messages.size == 1) && regex.match(messages[:email].first)
    end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
