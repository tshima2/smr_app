class SitesController < ApplicationController
  before_action  :set_site, only: [:show, :edit, :update, :destroy]
  def index
    @sites = current_user.keep_team.sites

    if params[:q]
      @q = current_user.keep_team.sites.ransack(params[:q])
      @q.combinator = "or" if(params["and_or"]=="1")
      @sites = @q.result distinct: true
    else
      @q = Site.ransack(nil)
    end 
  
    @sites = @sites.order(updated_at: :DESC).page(params[:page]).per(20)
  end
    
  def new
    @site = current_user.sites.build(team_id: current_user.keep_team_id)
  end

  def create
    @site = current_user.sites.build(site_params)
    @site.team_id ||= current_user.keep_team_id

    if @site.save
        redirect_to team_sites_path, notice: I18n.t('views.messages.create_site')
    else
      flash[:notice]=I18n.t('views.messages.failed_create_site')
      render :new
    end 
  end

  def edit
  end

  def update
    if @site.update(site_params)
      redirect_to team_sites_path, notice: I18n.t('views.messages.update_site')
    else
      flash[:notice]=I18n.t('views.messages.failed_update_site')
      render :edit
    end 
  end

  def destroy
    site_name=@site.name
    emails = @site.team.members.pluck(:email)
    emails << @site.team.owner.email

    if @site.destroy
      SiteMailer.destroy_mail(emails, site_name).deliver
      redirect_to team_sites_path, notice: I18n.t('views.messages.delete_site')
    else
      redirect_to team_sites_path, notice: I18n.t('views.messages.failed_to_delete_site')
    end
  end

  def show
    check_specified_team
   
    @comments = @site.comments
    @comment = @site.comments.build
    @image_posts = @site.image_posts
 end  

  private
  def site_params
    p = params.require(:site).permit(:team_id, :name, :address, :latitude, :longtitude, :memo, :tag_list, { label_ids: [] })
    p[:tag_list] = p[:tag_list].split(/[[:space:]]/).select {|li| li.length > 0}
    p[:label_ids] = p[:label_ids].select { |li| li.length > 0 }
    return p
  end

  def set_site
    begin
      @site = Site.find(params[:id])
    rescue
      redirect_to statics_top_path, alert: I18n.t('views.messages.invalid_site_specified')
    end
  end

  def check_specified_team
    if !(current_user.teams.pluck(:team_id).include?(params[:team_id].to_i))
      redirect_to statics_top_path, alert: I18n.t('views.messages.unauthorized_request')
    end 
  end

  def search_params
    params.require(:q).permit!
  end


end
