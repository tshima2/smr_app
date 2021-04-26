class SitesController < ApplicationController
  before_action  :set_site, only: [:show, :edit, :update, :destroy]
  def index
    #check_specified_team
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

#    if params[:back]
#      render :new
#    else
      if @site.save
        flash[:notice]=I18n.t('views.messages.create_site')
        redirect_to team_sites_path
      else
        flash[:alert]=I18n.t('views.messages.failed_create_site')
        render :new
      end
#    end
  end

  def edit
    if !(site_creator_or_team_owner?)
      flash[:alert]=I18n.t('views.messages.unauthorized_request')
      redirect_to statics_top_path
    end
  end

  def confirm
    @site = Site.new(site_params)

    if params[:file].present?
      require "rexml/document"
      kml = REXML::Document.new(File.new(params[:file].path).read)
      kml_h = Hash.from_xml(kml.to_s)
    
      @tags_str=[]; @comments_str=[]
      placemarks = kml_h["kml"]["Document"]["Folder"]["Placemark"]
      placemarks.each do |ha|
        mark = KmlPlaceMark.new(ha["name"], ha["description"], ha["Point"]["coordinates"])
        @tags_str << mark.to_tag
        @comments_str << mark.to_comment
      end
    end
  end

  def update
    if @site.update(site_params)
      flash[:notice]=I18n.t('views.messages.update_site')
      redirect_to team_sites_path, notice: I18n.t('views.messages.update_site')
    else
      flash[:alert]=I18n.t('views.messages.failed_update_site')
      render :edit
    end 
  end

  def destroy
    if !(site_creator_or_team_owner?)
      flash[:alert]=I18n.t('views.messages.unauthorized_request')
      redirect_to statics_top_path
    end

    site_name=@site.name
    emails = @site.team.members.pluck(:email)
    emails << @site.team.owner.email

    if @site.destroy
      SiteMailer.destroy_mail(emails, site_name).deliver
      flash[:notice]=I18n.t('views.messages.delete_site')
      redirect_to team_sites_path
    else
      flash[:alert]=I18n.t('views.messages.failed_to_delete_site')
      redirect_to team_sites_path
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
    p = params.require(:site).permit(:team_id, :name, :address, :latitude, :longtitude, :memo, :tag_list, { label_ids: [] }, { comments_str: [] }, { comments: [] })
    p[:tag_list] = p[:tag_list].split(/[[:space:]]/).select {|li| li.length > 0}
    p[:label_ids] = p[:label_ids].select { |li| li.length > 0 }
    if p[:comments_str] && p[:comments_str].length > 0
      p[:comments] = p[:comments_str].map { |cs| Comment.new(content: cs, user_id: current_user.id) }
      p.delete(:comments_str)
    end
    return p
  end

  def set_site
    begin
      @site = Site.find(params[:id])
    rescue
      flash[:alert]=I18n.t('views.messages.invalid_site_specified')
      redirect_to statics_top_path
    end
  end

  def site_creator_or_team_owner?
    ((current_user.id == @site.user_id) || (current_user.id == @site.team.owner.id)) ? true : false
  end

  def belong?(_team_id)
    current_user.teams.pluck(:team_id).include?(_team_id) ? true : false
  end

  def check_specified_team
    if !(belong?(params[:team_id].to_i))
      flash[:alert]=I18n.t('views.messages.unauthorized_request')
      redirect_to statics_top_path
    end 
  end

  def search_params
    params.require(:q).permit!
  end

  class KmlPlaceMark
    attr_accessor :name, :description, :coorinates
    def initialize(_name, _description, _coordinates)
      @name = _name.strip if _name.present?
      @description = _description.strip if _description.present?
      @coordinates = _coordinates.strip if _coordinates.present?
    end

    def to_tag
      "##{@name}"
    end

    def to_comment
      "[#{@name}]:#{@description}"
    end
  end 

end
