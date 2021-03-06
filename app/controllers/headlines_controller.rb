class HeadlinesController < ApplicationController
  before_action :make_api_public, only: [:index]
  respond_to :json

  def index
    headlines = Headline.where(snapshot_id: params[:snapshot_id]).order(id: :asc)
    render json: headlines, each_serializer: HeadlineSerializer
  end
end
