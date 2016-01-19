class HeadlinesController < ApplicationController
  def index
    headlines = Headline.where(snapshot_id: params[:id])
    render json: headlines, each_serializer: HeadlineSerializer
  end
end
