class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :title
      t.string :subtitle
      t.string :permalink

      t.timestamps null: false
    end
  end
end
