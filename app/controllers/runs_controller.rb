class RunsController < ApplicationController
  # list all runs
  # GET /runs
  def index
    render json: { runs: redis.keys }, status: 200
  end

  # create a new run, with 1 or more test file paths
  # will over-write exiting run if IDs are identical
  # POST /runs
  def create
    if create_run
      render json: 'Created', status: 204
    else
      render json: 'Bad Request', status: 400
    end
  end

  # destroy a specific run
  # DELETE /runs/:id
  def destroy
    if destroy_run
      render json: 'Destroyed', status: 204
    else
      render json: 'Bad Request', status: 400
    end
  end

  # destroy all runs
  # DELETE /runs/_clear
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
    params[:id].present? && redis.del(params[:id]) > 0
  end

  def run_id
    run_params[:id]
  end

  def test_file_paths
    @test_file_paths ||= run_params
      .fetch(:test_file_paths, [])
      .select { |tfp| tfp.present? }
  end

  def run_params
    params.require(:run).permit(:id, test_file_paths: [])
  end
end
