class AddThumbField < ActiveRecord::Migration
  def change
    add_column :snapshots, :thumbnail, :string
  end
end
