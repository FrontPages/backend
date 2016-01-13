class AddIndexToHeadline < ActiveRecord::Migration
  def change
    add_index :headlines, :created_at
  end
end
