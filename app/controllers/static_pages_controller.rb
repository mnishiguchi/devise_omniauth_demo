class StaticPagesController < ApplicationController
  def home
    redirect_to current_client and return if client_signed_in?
    redirect_to current_admin and return if admin_signed_in?
  end
end
