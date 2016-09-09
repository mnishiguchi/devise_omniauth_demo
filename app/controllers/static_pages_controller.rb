class StaticPagesController < ApplicationController
  layout :resolve_layout

  def home
    redirect_to current_client and return if client_signed_in?
    redirect_to current_admin and return if admin_signed_in?
  end

  private

    # http://stackoverflow.com/a/3025806/3837223
    def resolve_layout
      case action_name
      when "home"
        "application_with_property_search"
      else
        "application"
      end
    end
end
