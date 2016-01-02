class CreateSnapshots < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.string :filename
      t.integer :height
      t.integer :width
      t.integer :size
      t.references :site, index: true

      t.timestamps
    end
  end
end
