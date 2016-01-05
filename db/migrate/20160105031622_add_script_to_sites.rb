class AddScriptToSites < ActiveRecord::Migration
  def change
    add_column :sites, :script, :text
  end
end
