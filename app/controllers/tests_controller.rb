class TestsController < ApplicationController
  # creates queue of test (file paths) to run.
  # hit once during setup phase.
  def new

  end

  # pops next test(s) off of queue and sends in response.
  def next

  end
end
