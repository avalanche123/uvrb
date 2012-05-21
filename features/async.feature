Feature: wake up another event loop

  UV::Loop cannot be shared by multiple threads. To wake up a control loop in a different
  thread, use UV::Loop#async, which is thread safe

  Scenario: wake up an event loop from a different thread
    Given a file named "async_example.rb" with:
      """
      require 'uvrb'

      count = 0
      loop  = UV::Loop.default

      timer = loop.timer
      timer.start(0, 100) do |e|
        count += 1
        Thread.pass
      end

      callback = loop.async do |e|
        stopper = loop.timer
        stopper.start(800, 0) do |e|
          timer.close {}
          callback.close {}
          stopper.close {}
        end
      end

      Thread.new(callback) do |proc|
        proc.call
      end

      loop.run

      abort "failure, count is #{count}" if count >= 11
      """
    When I run `ruby async_example.rb`
    Then the exit status should be 0