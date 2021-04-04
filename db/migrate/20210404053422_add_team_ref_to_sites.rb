class AddTeamRefToSites < ActiveRecord::Migration[5.2]
  def change
    add_reference :sites, :team, foreign_key: true
  end
end
