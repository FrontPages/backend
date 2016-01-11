class StoriesController < ApplicationController

	before_filter :make_api_public, only: [:trending]

	respond_to :json

	def trending

    trending_query = "select t1.url, t2.title, t1.cnt
      from (select url, count(distinct title) cnt from headlines where created_at >= NOW() - '1 day'::INTERVAL group by url having count(distinct title) >= 5) t1
      join (select distinct on (url) url, title from headlines where created_at >= NOW() - '1 day'::INTERVAL order by url, created_at desc) t2
      on t1.url = t2.url order by t1.cnt desc"

		@stories = ActiveRecord::Base.connection.execute(trending_query)
		render json: {stories: @stories}

	end

end
