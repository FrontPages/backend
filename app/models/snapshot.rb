class Snapshot < ActiveRecord::Base
  belongs_to :site
  has_many :headlines
  has_many :stories, through: :headlines
  has_many :collection_snapshots
  has_many :collections, through: :collection_snapshots

  def filename_s3
    # gsub is required due to Amazon S3 encoding glitch: https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1003633
    filename.gsub("+", "%2B")
  end
end
