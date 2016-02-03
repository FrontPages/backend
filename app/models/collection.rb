class Collection < ActiveRecord::Base
  has_many :collection_snapshots
  has_many :snapshots, through: :collection_snapshots
end
