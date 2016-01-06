class AddPartialIndexToSnapshot < ActiveRecord::Migration
  def change
    add_index :snapshots, :created_at, order: {created_at: "DESC"}, where: "keyframe = true"
  end
end
