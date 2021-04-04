class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.float :latitude
      t.float :longtitude
      t.text :memo

      t.timestamps
    end
  end
end
