Feature: triggering callbacks while nothing else is happening

  Idle watchers trigger events when no other events of the same or higher priority are
  pending (prepare, check and other idle watchers do not count).
  
  That is, as long as your process is busy handling sockets or timeouts (or even signals,
  imagine) of the same or higher priority it will not be triggered. But when your process
  is idle (or only lower-priority watchers are pending), the idle watchers are being
  called once per event loop iteration - until stopped, that is, or your process receives
  more events and becomes busy again with higher priority stuff.

  Scenario: when you've got nothing better to do...
    Given a file named "idle_example.rb" with:
      """
      require 'uvrb'
      
      idle_calls = 0
      loop       = UV::Loop.default
      
      idle = loop.idle
      idle.start do |e|
        raise e if e
        idle_calls += 1
      end
      
      timer = loop.timer
      timer.start(1, 0) do |e|
        raise e if e
      end
      
      stopper = loop.timer
      stopper.start(10, 0) do |e|
        raise e if e
        idle.close {}
        timer.close {}
        stopper.close {}
      end
      
      loop.run
      
      abort "idle not called #{idle_calls}" unless idle_calls > 0
      """
    When I run `ruby idle_example.rb`
    Then the exit status should be 0