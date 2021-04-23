class PlacemarksController < ApplicationController

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

  def new
    if params[:site_id].present?
        @site = Site.find(params[:site_id])
    end
  end

  def create
    begin
      if params[:site_id].present?
        @site = Site.find(params[:site_id])
      end

      kml = REXML::Document.new(File.new(params[:file].path).read)
      kml_h = Hash.from_xml(kml.to_s)

      @tag_strings=[]; @comment_strings=[] 
      placemarks = kml_h["kml"]["Document"]["Folder"]["Placemark"]
      placemarks.each do |ha|
        mark = KmlPlaceMark.new(ha["name"], ha["description"], ha["Point"]["coordinates"])
        @tag_strings << mark.to_tag
        @comment_strings << mark.to_comment
      end

      flash[:notice] = I18n.t('views.messages.create_hashtags_from_kml')
      if @site.present?
        redirect_to edit_team_site_path(team_id: @site.team_id, id: @site.id, tag_strings: @tag_strings)
      else
        redirect_to new_team_site_path(team_id: current_user.keep_team_id, tag_strings: @tag_strings)
      end
    
    rescue => e
      flash[:alert] = I18n.t('views.messages.some_error_occured')
      redirect_to statics_top_path
    end
  
  end

end