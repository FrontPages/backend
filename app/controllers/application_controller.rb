class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def make_api_public
    headers['Access-Control-Allow-Origin'] = '*'
  end

  def check_api_key
    head :unauthorized unless params[:api_key] == ENV['FRONT_PAGES_API_KEY']
  end

end
