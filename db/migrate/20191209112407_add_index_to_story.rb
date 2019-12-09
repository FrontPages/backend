class AddIndexToStory < ActiveRecord::Migration
  def change
    add_index :stories, :url
  end
end
