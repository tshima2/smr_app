class CreateSiteLabellings < ActiveRecord::Migration[5.2]
  def change
    create_table :site_labellings do |t|
      t.references :site, foreign_key: true
      t.references :label, foreign_key: true

      t.timestamps
    end
  end
end
