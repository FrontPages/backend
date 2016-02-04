class CollectionSerializer < ActiveModel::Serializer
  # embed :ids, include: false
  attributes :id, :title, :subtitle, :permalink, :snapshots
  # has_many :snapshots
end
