class UsersController < ApplicationController
  before_action :authenticate_user!, except: :finish_signup

  # GET   /users/:id/finish_signup - Add email form
  # PATCH /users/:id/finish_signup - Update user data based on the form
  def finish_signup
    @user = User.find(params[:id])

    if request.patch?
      # The user email was successfully submitted and the email is not confirmed yet.
      if @user.update(user_params) && !@user.confirmed?
        @user.send_confirmation_instructions
        flash[:info] = 'We sent you a link to sign in. Please check your inbox.'
        redirect_to root_url
      # The same email is already in the database.
      elsif email_already_taken?
        # TODO: custom confirmation email?
        # When confirmation link is clicked, we need to associate this email
        # with the oauth user.
        # @user.send_confirmation_instructions
        # flash[:info] = 'We sent you a link to sign in. Please check your inbox.'
        flash[:warning] = 'TODO: email_already_taken. When confirmation link is clicked, we need to associate this email with the oauth user.'
        redirect_to root_url
      end
    end
  end

  private

    def email_already_taken?
      regex = /has already been taken/
      messages = @user.errors.messages
      (messages.size == 1) && regex.match(messages[:email].first)
    end

    def user_params
      accessible = [ :email ]

      # Ignore password if password is blank.
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
