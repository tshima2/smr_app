class AddDefaultToColumn < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :keep_team_id, from: nil, to: 1
  end
end
