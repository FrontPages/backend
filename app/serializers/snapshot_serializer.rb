class SnapshotSerializer < ActiveModel::Serializer
  attributes :created_at, :file_path, :id, :site_id
end
