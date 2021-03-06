class SitesController < ApplicationController

	before_action :make_api_public, only: [:index]

	respond_to :json

	def index

		@sites = Site.all.order(name: :asc)
		render json: {sites: @sites}

	end

end
