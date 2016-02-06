class Headline < ActiveRecord::Base
  include PgSearch

  pg_search_scope(
    :search,
    against: %i(
      title
    ),
    using: {
      tsearch: {
        dictionary: "english"
      }
    }
  )

  belongs_to :snapshot
  belongs_to :story
  has_one :site, through: :story
end
