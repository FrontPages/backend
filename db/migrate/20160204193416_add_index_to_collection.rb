class AddIndexToCollection < ActiveRecord::Migration
  def change
    add_index :collections, :permalink, :unique => true
  end
end
