class SitesController < ApplicationController
  before_action  :authenticate_user!, only: [:index, :new, :create]
  before_action  :set_site, only: [:show, :edit, :update, :destroy]

  def new
    @team = Team.find(params[:team_id])
    @site = Site.new
  end

  def create
    @site = current_user.sites.build(name: params[:name])
    @site.team = Team.find(params[:team_id])
    if(@site.save)
      redirect_to team_sites_path, notice: I18n.t('views.messages.create_site')
    else
      render :new
    end 
  end

  def destroy
    site_name=@site.site_name
=begin  
    emails = @site.team.members.pluck(:email)
    emails << @site.team.owner.email

    if @site.destroy
      SiteMailer.destroy_mail(emails, site_title).deliver
      redirect_to team_sites_path, notice: I18n.t('views.messages.delete_site')
    else
      redirect_to team_sites_path, notice: I18n.t('views.messages.failed_to_delete_site')
    end
=end
  end

  def show
    @comments = @site.comments
    @comment = @site.comments.build
    @image_posts = @site.image_posts
  end

  
  def index
#    @sites = Site.all
    @sites = current_user.keep_team.sites
  end

  private
  def site_param
    params.fetch(:site, {}).permit %i[name address latitude longtitude memo]
  end

  def set_site
    @site = Site.find(params[:id])
  end
end
