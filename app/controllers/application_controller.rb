class ApplicationController < ActionController::API
  before_action :validate_api_key, except: [:ping, :route_not_found]

  def ping
    render json: "PONG", status: :ok
  end

  def route_not_found
    render json: 'Not Found', status: 404
  end

  private

  def api_key
    request.headers["X-SCIR-AUTH"]
  end

  def validate_api_key
    return false if Rails.application.config.x.scir.api_key.nil?
    unless Rails.application.config.x.scir.api_key == api_key
      render json: "Unauthorized", status: 401
    end
  end

  def redis
    Redis.new
  end
end
