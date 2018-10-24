class TestsController < ApplicationController
  # lists all test file paths for a given run
  def index
    # I think it's safe to assume there is a run_id, otherwise it'd be
    # a routing error that rails picks up sooner anyway.
    if redis.keys.include?(run_id)
      render json: { tests: redis.lrange(run_id, 0, -1) }, status: 200
    else
      render json: 'Not Found', status: 404
    end
  end

  # pops next n-number tests off of queue and sends in response
  def pop
    if fetched_tests.any?
      render json: { tests: fetched_tests }, status: 200
    else
      redis.del(run_id)
      render json: 'Not Found', status: 404
    end
  end

  private

  def count
    # should count be limited? maybe 100?
    [params.fetch(:count, 1).to_i, 1].max # in case they provide no count or a count of 0
  end

  def fetch_test
    redis.lpop(run_id)
  end

  def fetched_tests
    # memoized because this modifies data in redis
    # i.e. we don't want to pop tests twice.
    @fetched_tests ||= Array.new(count) { fetch_test }.compact
  end

  def run_id
    params[:run_id]
  end
end
