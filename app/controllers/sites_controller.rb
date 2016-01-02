class SitesController < ApplicationController

	before_filter :make_api_public, only: [:index]

	respond_to :json

	def index

		@sites = Site.all
		render json: {sites: @sites}

	end

end
