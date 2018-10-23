class RunsController < ApplicationController
  # list all runs
  def index
    render json: { runs: redis.keys }, status: 200
  end

  # create a new run, with 1 or more test file paths
  # will over-write exiting run if IDs are identical
  def create
    if create_run
      render json: 'Created', status: 204
    else
      render json: 'Bad Request', status: 400
    end
  end

  # destroy a specific run
  def destroy
    if destroy_run
      render json: 'Destroyed', status: 204
    else
      render json: 'Bad Request', status: 400
    end
  end

  # destroy all runs
  def clear
    #
    # CAUTION:  Only use this end-point if stream-ci-runs-api
    #           is the only service using this redis instance.
    #           Otherwise you will accidentally delete _all_
    #           keys, even those used by other services.
    #
    redis.flushdb
    render json: 'Destroyed All', status: 200
  end

  private

  def create_run
    run_id.present? &&
      test_file_paths.any? &&
      redis.del(run_id) &&
      redis.rpush(run_id, test_file_paths)
  end

  def destroy_run
    run_id.present? && redis.del(run_id)
  end

  def run_id
    run_params[:run_id]
  end

  def test_file_paths
    run_params[:test_file_paths]
  end

  def run_params
    params.require(:run).permit(:run_id, test_file_paths: [])
  end
end
