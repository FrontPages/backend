class MakeTableChanges < ActiveRecord::Migration
  def change

    # remove_reference(:headlines, :site, index: true)
    add_reference :headlines, :story, index: true
    add_column :snapshots, :keyframe, :boolean, :default => true
    add_column :snapshots, :searchable_headlines, :text

  end
end
