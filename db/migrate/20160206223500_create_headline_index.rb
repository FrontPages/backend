class CreateHeadlineIndex < ActiveRecord::Migration

  def up
    execute "CREATE INDEX index_title ON headlines USING GIN(to_tsvector('english', title))"
  end

  def down
  	execute "DROP INDEX index_title"
  end

end
