class CreateHeadlines < ActiveRecord::Migration
  def change
    create_table :headlines do |t|
      t.string :title
      t.string :url
      t.string :snapshot
      t.references :site, index: true

      t.timestamps
    end
  end
end
