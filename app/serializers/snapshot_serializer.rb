class SnapshotSerializer < ActiveModel::Serializer
  attributes :created_at, :file_path, :site
end
