class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :url
      t.string :selector
      t.string :shortcode

      t.timestamps
    end
  end
end
