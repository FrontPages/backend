class HeadlineSerializer < ActiveModel::Serializer
  attributes :id, :snapshot_id, :story_id, :title, :url
end
