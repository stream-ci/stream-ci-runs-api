class ApplicationController < ActionController::API
  def ping
    render json: "pong", status: :ok
  end
end
