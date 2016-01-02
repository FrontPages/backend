class SnapshotsController < ApplicationController

	before_filter :make_api_public, only: [:index]

	respond_to :json

	def index

		@snapshots = Snapshot.all
		render json: {snapshots: @snapshots}

	end

end
