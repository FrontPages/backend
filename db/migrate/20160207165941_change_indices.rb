class ChangeIndices < ActiveRecord::Migration
  def change
    execute "DROP INDEX index_title"
    execute "CREATE INDEX index_on_title ON headlines USING GIN(to_tsvector('english', coalesce(\"headlines\".\"title\"::text, '')))"
  end
end
