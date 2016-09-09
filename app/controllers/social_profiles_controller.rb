class SocialProfilesController < ApplicationController
  before_action :authenticate_admin!, only: :index
  before_action :authenticate_user!, only: :destroy
  before_action :correct_user!, only: :destroy

  def index
    @social_profiles = SocialProfile.all
  end

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
