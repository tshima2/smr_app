module SitesHelper
  def choose_new_or_edit
    if action_name=="new" || action_name=="create"
      team_sites_path
    elsif action_name=="edit" || action_name=="update"
      team_site_path
    end
  end
end
