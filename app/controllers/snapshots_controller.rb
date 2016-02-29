class SnapshotsController < ApplicationController
	before_filter :make_api_public, only: [:index, :search]
	respond_to :json

	def index
		snapshots = Snapshot.where(keyframe: true, site_id: params[:site_id]).order(created_at: :desc)
		render json: snapshots, each_serializer: SnapshotSerializer
	end

  def search
    if params.has_key?(:no_index)
      snapshots = Snapshot.includes(:headlines).where("headlines.title ilike ?", "%#{params[:query]}%").references(:headlines).order(created_at: :desc)
    else
      snapshots = Snapshot.where("id in (?)", Headline.select(:snapshot_id).search("#{params[:query]}")).order(created_at: :desc)
    end
    render json: snapshots, each_serializer: SnapshotSerializer
  end

end
