class HeadlinesController < ApplicationController
  def index
    headlines = Headline.where(snapshot_id: params[:snapshot_id])
    render json: headlines, each_serializer: HeadlineSerializer
  end
end
