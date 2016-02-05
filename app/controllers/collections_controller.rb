class CollectionsController < ApplicationController
  before_filter :make_api_public, only: [:index, :show]
  respond_to :json

  def index
    collections = Collection.all.order(id: :asc)
    render json: collections, each_serializer: CollectionSerializer
  end

  def show
    collection = Collection.where(permalink: params[:permalink]).order(id: :asc)
    render json: collection, each_serializer: CollectionSerializer
  end

  def create
    collection = Collection.new(collection_params)
    if collection.permalink.nil? || collection.permalink == ""
      begin
        collection.permalink = SecureRandom.urlsafe_base64
      end while Collection.exists?(:permalink => collection.permalink)
    end
    collection.save if collection.snapshots.count > 0
  end

  private

  def collection_params
    params.require(:collection).permit(:title, :subtitle, :permalink, :snapshots => [:id])
  end

end
