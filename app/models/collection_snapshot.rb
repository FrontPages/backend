class CollectionSnapshot < ActiveRecord::Base
  belongs_to :collection
  belongs_to :snapshot
end
