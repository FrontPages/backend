class SnapshotsController < ApplicationController
	before_filter :make_api_public, only: [:index]
	respond_to :json

	def index
		@snapshots = Snapshot.where(:keyframe => true).order(created_at: :desc)
		render json: @snapshots
	end
end
