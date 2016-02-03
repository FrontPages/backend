class CreateCollectionSnapshots < ActiveRecord::Migration
  def change
    create_table :collection_snapshots do |t|
      t.references :collection, index: true, foreign_key: true
      t.references :snapshot, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
