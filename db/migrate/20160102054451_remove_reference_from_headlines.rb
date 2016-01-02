class RemoveReferenceFromHeadlines < ActiveRecord::Migration
  def change
    remove_reference :headlines, :site, index: true
  end
end
