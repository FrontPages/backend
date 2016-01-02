class Site < ActiveRecord::Base
  has_many :snapshots
  has_many :stories
  has_many :headlines, through: :stories
end
