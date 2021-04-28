module SitesHelper
  def choose_new_or_edit
    if action_name=="new" || action_name=="create" || action_name=="confirm"
      team_sites_path
    elsif action_name=="edit" || action_name=="update" || action_name=="confirm_edit"
      team_site_path
    end
  end

  def choose_method
     if action_name=="new" || action_name=="create" || action_name=="confirm"
       :post
     elsif action_name=="edit" || action_name=="update" || action_name=="confirm_edit"
       :patch
     end
   end
 
  def choose_new_or_edit_confirm
    if action_name == "new" || action_name == "create" || action_name == "confirm"
      confirm_team_sites_path
    elsif action_name == "edit" || action_name == "update" || action_name == "confirm_edit"
      confirm_edit_team_site_path
    end
  end
end
