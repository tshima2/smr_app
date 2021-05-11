class SitesController < ApplicationController
  before_action  :check_guest_user, only: [:new, :edit, :destroy]
  before_action  :set_site, only: [:show, :edit, :update, :destroy]

  def index
    #check_specified_team
    @sites = current_user.keep_team.sites

    if params[:q]
      @q = current_user.keep_team.sites.ransack(search_params)
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

  def confirm    
    @site = Site.new(site_params)
    load_kml(site_params["kml"].path) if site_params["kml"].present?

    @site.name = @document_name unless @site.name.present?
    @site.memo = @document_description unless @site.memo.present?
  end

  def create
    @site = current_user.sites.build(site_params)
    @site.team_id ||= current_user.keep_team_id

    if params[:back]
      render :new
    else
      if @site.save
        flash[:notice]=I18n.t('views.messages.create_site')
        redirect_to team_sites_path
      else
        flash.now[:alert]=I18n.t('views.messages.failed_create_site')
        render :new
      end
    end
  end

  def edit
    if !(site_creator_or_team_owner?)
      flash[:alert]=I18n.t('views.messages.unauthorized_request')
      redirect_to statics_top_path
    end
  end

  def confirm_edit
    @site=Site.new(site_params)   
    if (stored_site = Site.find(params[:id]))
      @site.comments = stored_site.comments
      @site.kml = stored_site.kml unless @site.kml.url
    end

    load_kml(site_params["kml"].path) if site_params["kml"].present?
    @site.name = @document_name if @document_name.present?
    @site.memo = @document_description if @document_description.present?
      
    render "confirm"
  end

  def update
    if params[:back]
      render :edit
    else
      if @site.update(site_params)
        flash[:notice]=I18n.t('views.messages.update_site')
        redirect_to team_sites_path
      else
        flash.now[:alert]=I18n.t('views.messages.failed_update_site')
        render :edit
      end
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

    if(@site.kml.url)
      require "open-uri"
      require "rexml/document"
      #require "json/pure"     
      io = OpenURI.open_uri(@site.kml.url)
      kml = REXML::Document.new(io.read)
      placemarks = REXML::XPath.match(kml, '//Placemark')

=begin
      _points << ["<h1>東京</h1><p>人が多い</p>", 35.681391, 139.766103]
      _points << ["大阪", 34.702398, 135.495188]
      _points << ["札幌", 43.068612, 141.350768]
      @points = _points.to_json
=end

@points =
        placemarks.map do |elem|
          elem_ha = Hash.from_xml(elem.to_s)
          ha = elem_ha["Placemark"]
          if ha["Point"]
            coordinates = ha["Point"]["coordinates"].split(",").map {|s| s.to_f}
            coordinates.unshift("<h5><strong>\##{ha["name"]}</strong></h5><span>#{ha["description"]}</span>")
          end
        end.compact.to_json 

=begin      
      _points = []; _line_strings = []; _polygons=[]
      placemarks.each do |elem|
        elem_ha = Hash.from_xml(elem.to_s)
        ha = elem_ha["Placemark"]
        if ha["Point"]
          coordinates = ha["Point"]["coordinates"].split(",").map {|s| s.to_f}
          coordinates.unshift("<h5><strong>\##{ha["name"]}</strong></h5><span>#{ha["description"]}</span>")
          _points << coordinates
        elsif ha["LineString"]
          coordinates = ha["LineString"]["coordinates"].split(",").map {|s| s.to_f}
          coordinates.unshift("<h5><strong>\##{ha["name"]}</strong></h5><span>#{ha["description"]}</span>")
          _line_strings << coordinates
        elsif ha["Polygon"]
          extrude = ha["Polygon"]["extrude"]
          altitudeMode = ha["Polygon"]["altitudeMode"]
          outer_coordinates = ha["Polygon"]["outerBoundaryIs"]["LinearRing"]["coordinates"].split(",").map {|s| s.to_f}
          outer_coordinates.unshift(altitudeMode)
          outer_coordinates.unshift(extrude)
          outer_coordinates.unshift("<h5><strong>\##{ha["name"]}</strong></h5><span>#{ha["description"]}</span>")
          _polygons << coordinates
        end
      end 
      @points = _points.compact.to_json
      @line_strings = _line_strings.compact.to_json
      @polygons = _polygons.compact.to_json
=end
    end
  end

  private
  def site_params
    p = params.require(:site).permit(:team_id, :name, :address, :latitude, :longtitude, :memo, :kml, :kml_cache, :tag_list, { label_ids: [] }, { comments_str: [] }, { comments: [] })
    p[:tag_list] = p[:tag_list].split(/[[:space:]]/).select {|li| li.length > 0}
    p[:label_ids] = p[:label_ids].select { |li| li.length > 0 }
    if p[:comments_str] && p[:comments_str].length > 0
      p[:comments] = p[:comments_str].map { |cs| Comment.new(content: cs, user_id: current_user.id) }
      p.delete(:comments_str)
    end
    return p
  end

  def set_site
    if !(@site = Site.find_by(id: params[:id]))
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
    sp = params.require(:q).permit!
    if sp[:tags_name_cont] && sp[:tags_name_cont].length > 0
      sp[:tags_name_cont_any] = sp[:tags_name_cont].split(/[[:space:]]/).select {|val| val.length > 0}
      sp.delete(:tags_name_cont)
    end
    return sp
  end

  def load_kml(_path)
    begin
      require "rexml/document"
      kml = REXML::Document.new(File.new(_path).read)
      @document_name = REXML::XPath.match(kml, '//Document/name')[0].text
      @document_description = REXML::XPath.match(kml, '//Document/description')[0].text

      placemarks = REXML::XPath.match(kml, '//Placemark')
      placemarks_ha = placemarks.map { |elem| Hash.from_xml(elem.to_s) }  
      
      @tags_str=[]; @comments_str=[]
      placemarks_ha.each do |elem|
        ha = elem["Placemark"]
        mark = KmlPlaceMark.new(ha["name"], ha["description"], (ha.has_key?("Point") ? ha["Point"]["coordinates"] : nil))
        @tags_str << mark.to_tag
        @comments_str << mark.to_comment
      end
    rescue
      flash.now[:info]=I18n.t('views.messages.unexpected_file_format')
    end
  end

  class KmlPlaceMark
    #attr_accessor :name, :description, :coorinates
    def initialize(_name, _description, _coordinates)
      @name = _name.strip if _name.present?
      @description = _description.strip if _description.present?
      @coordinates = _coordinates.strip if _coordinates.present?
    end

    def to_tag
      "##{@name}"
    end

    def to_comment
      "[\##{@name}]:#{@description}"
    end
  end

end
