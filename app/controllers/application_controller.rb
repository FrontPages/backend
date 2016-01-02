class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def make_api_public
    headers['Access-Control-Allow-Origin'] = '*'
  end

end
