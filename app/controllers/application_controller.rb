class ApplicationController < ActionController::API
  before_action :validate_api_key, except: [:ping]

  def ping
    render json: "PONG", status: :ok
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
