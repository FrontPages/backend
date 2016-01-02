class ModifyHeadline < ActiveRecord::Migration
  def change
    remove_column :headlines, :snapshot
    add_reference :headlines, :snapshot, index: true
  end
end
