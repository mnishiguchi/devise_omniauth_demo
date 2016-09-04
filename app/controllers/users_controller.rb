class UsersController < ApplicationController
  before_action :authenticate_user!, except: :finish_signup

  # GET   /users/:id/finish_signup - Add email form
  # PATCH /users/:id/finish_signup - Update user data based on the form
  def finish_signup
    @user = User.find(params[:id])

    if request.patch?
      if signed_up_but_not_confirmed? || email_already_taken?
        @user.send_confirmation_instructions
        flash[:info] = 'We sent you a link to sign in. Please check your inbox.'
        redirect_to root_url
      end
    end
  end

  private

    # Returns true if the user was successfully signed up but
    # his/her email is not confirmed yet.
    def signed_up_but_not_confirmed?
      @user.skip_confirmation_notification!
      @user.update(user_params) && !@user.confirmed?
    end

    # Returns true if the submitted email already exists in the database.
    # Returns false if there are any other error messages.
    def email_already_taken?
      messages = @user.errors.messages
      (messages.size == 1) && (messages[:email].first == "has already been taken")
    end

    def user_params
      accessible = [ :email ]

      # Ignore password if password is blank.
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
