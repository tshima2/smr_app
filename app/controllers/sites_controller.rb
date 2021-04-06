class SitesController < ApplicationController
  before_action  :authenticate_user!, only: [:index, :new, :create]
  def new
  end

  def create
  end
  
  def index
    @sites = Site.all
  end

end
