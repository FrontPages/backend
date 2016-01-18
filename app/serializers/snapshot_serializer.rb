class SnapshotSerializer < ActiveModel::Serializer
  attributes :created_at, :file_path, :site_id
end
