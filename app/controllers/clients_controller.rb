class ClientsController < ApplicationController

  def show
    @properties = current_client.properties
  end
end
