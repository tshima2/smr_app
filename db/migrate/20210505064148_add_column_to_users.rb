class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :guest, :boolean, null: false, default: false
  end
end
