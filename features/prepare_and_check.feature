Feature: customise your event loop

  Prepare and check watchers are usually (but not always) used in tandem: prepare watchers
  get invoked before the process blocks and check watchers afterwards.

  Scenario: prepare loop
    Given a file named "prepare_check_example.rb" with:
      """
      require 'uvrb'

      loop = UV::Loop.default

      prepared = false
      checked  = false

      prepare = loop.prepare
      prepare.start do |e|
        puts "preparing"
        abort e.inspect if e
        prepared = true
      end

      check = loop.check
      check.start do |e|
        puts "checking"
        abort e.inspect if e
        abort "not prepared" unless prepared
        checked = true
      end

      timer = loop.timer
      timer.start(0, 200) do |e|
        puts "running cycles"
      end

      stopper = loop.timer
      stopper.start(2000, 0) do |e|
        timer.close {}
        prepare.close {}
        check.close {}
        stopper.close {}
      end

      loop.run

      abort "not checked" unless checked
      """
    When I run `ruby prepare_check_example.rb`
    Then the exit status should be 0