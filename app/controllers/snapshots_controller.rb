class SnapshotsController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :make_api_public, only: [:index, :search, :create]
  before_filter :check_api_key, only: [:create]
  respond_to :json

  def index
    if params.has_key?(:limit)
      snapshots = Snapshot.where(keyframe: true, site_id: params[:site_id]).order(created_at: :desc).limit(params[:limit].to_i)
    else
      snapshots = Snapshot.where(keyframe: true, site_id: params[:site_id]).order(created_at: :desc)
    end
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

  def create
    new_snapshot = Snapshot.new :filename => snapshot_params[:filename], :thumbnail => snapshot_params[:thumbnail], :site_id => snapshot_params[:site_id]
    new_snapshot.save

    snapshot_params[:headlines].each do |headline|

      begin

        # if Story doesn't exist, create it before creating the Headline
        if Story.where(:url => headline[:url]).count == 0

          new_story = Story.new :url => headline[:url], :site_id => snapshot_params[:site_id]
          new_story.save

          new_headline = Headline.new :title => headline[:title], :url => headline[:url], :snapshot => new_snapshot, :story => new_story
          new_headline.save

        # if Story does exist, link it to the new Headline when it's created
        else

          new_headline = Headline.new :title => headline[:title], :url => headline[:url], :snapshot => new_snapshot, :story => Story.where(:url => headline[:url]).first
          new_headline.save

        end

      rescue
      end

    end

  end

  private

  def snapshot_params
    params.require(:api_key)
    params.require(:snapshot).permit(:site_id, :filename, :thumbnail, :headlines => [:title, :url])
  end

end
