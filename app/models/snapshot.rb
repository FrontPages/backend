class Snapshot < ActiveRecord::Base
  belongs_to :site
  has_many :headlines
  has_many :stories, through: :headlines
  has_many :collection_snapshots
  has_many :collections, through: :collection_snapshots

  def file_path
    # gsub is required due to Amazon S3 encoding glitch: https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1003633
    unless thumbnail.nil?
      ENV['S3_FILE_PREFIX'] + thumbnail.gsub("+", "%2B")
    else
      ENV['S3_FILE_PREFIX'] + filename.gsub("+", "%2B")
    end
  end
end
