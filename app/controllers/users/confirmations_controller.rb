# http://www.rubydoc.info/github/plataformatec/devise/Devise/RegistrationsController
class Users::ConfirmationsController < Devise::ConfirmationsController

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    flash_success = "Successfully confirmed"

    if resource.errors.empty?
      sign_in(@user)
      redirect_to root_url, notice: flash_success
    elsif @user.email_already_confirmed?
      # If the only error is that user is already confirmed, just log him/her in.
      sign_in(@user)
      redirect_to root_url
    elsif @user.email_exists_in_database?
      # If the same email is in the database and the old user account has no
      # social profiles associated with it, sign in the user with new account and
      # archive the old one by marking its email.
      email = @user.email

      # Check if there is a user registered with the same email in the database
      # because email duplication is restricted.
      # We will keep the new one and archive the old one.
      if (old_user = User.find_by email: email)
        @user.merge_old_account!(old_user)
      end

      # set_flash_message(:notice, :confirmed) if is_flashing_format?
      sign_in(@user)
      redirect_to root_url, notice: flash_success
    else
      # If there are other errors, we need to confirm the user's email again.
      flash[:danger] = "Error confirming email. Please sign in again."
      redirect_to root_url
    end
  end
end
