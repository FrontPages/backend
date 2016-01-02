class Story < ActiveRecord::Base
  belongs_to :site
  has_many :headlines
  has_many :snapshots, through: :headlines
end
