class SocialProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!

  def destroy
    @profile.destroy
    provider_name = @profile.provider == "google_oauth2" ? "Google" : @profile.provider.capitalize
    flash[:success] = "Disconnected from #{provider_name}"
    redirect_to edit_user_registration_url
  end

  private

    def correct_user!
      @profile = SocialProfile.find(params[:id])
      unless @profile.user_id == current_user.id
        redirect_to root_url and return
      end
    end
end
