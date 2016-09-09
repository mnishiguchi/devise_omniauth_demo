class ClientsController < ApplicationController
  before_action :authenticate_admin!, only: :index

  def index
    @clients = Client.all
  end

  def show
    @properties = current_client.properties
  end
end
