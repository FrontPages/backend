class SnapshotSerializer < ActiveModel::Serializer
  attributes :created_at, :filename_s3, :id, :site_id
end
