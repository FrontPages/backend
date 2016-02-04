class CollectionsController < ApplicationController
  before_filter :make_api_public, only: [:index, :show]
  respond_to :json

  def index
    collections = Collection.all.order(id: :asc)
    render json: collections, each_serializer: CollectionSerializer
  end

  def show
    collection = Collection.where(id: params[:id]).order(id: :asc)
    render json: collection, each_serializer: CollectionSerializer
  end

end
