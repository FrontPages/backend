class Headline < ActiveRecord::Base
  belongs_to :snapshot
  belongs_to :story
  has_one :site, through: :story
end
