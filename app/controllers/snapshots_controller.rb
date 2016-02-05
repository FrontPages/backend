class SnapshotsController < ApplicationController
	before_filter :make_api_public, only: [:index, :search]
	respond_to :json

	def index
		snapshots = Snapshot.where(:keyframe => true).order(created_at: :desc)
		render json: snapshots, each_serializer: SnapshotSerializer
	end

  def search
    snapshots = Snapshot.includes(:headlines).where("headlines.title ilike ?", "%#{params[:query]}%").references(:headlines).order(created_at: :desc)
    render json: snapshots, each_serializer: SnapshotSerializer
  end

end
