Feature: Named pipes

  Named pipes are basically unix pipes with a pre-defined location. They can be used for
  unidirectional inter-process communication in a producer/consumer fashion

  Scenario: unidirectional pipeline
    Given a named pipe "/tmp/exchange-pipe.pipe"
    And a file named "pipe_producer_example.rb" with:
      """
      require 'uvrb'

      loop = UV::Loop.default

      pipe     = File.open("/tmp/exchange-pipe.pipe", File::RDWR|File::NONBLOCK)
      producer = loop.pipe

      producer.open(pipe.fileno)

      heartbeat = loop.timer

      heartbeat.start(0, 200) do |e|
        raise e if e

        producer.write("workload") { |e| raise e if e }
      end

      stopper = loop.timer

      stopper.start(2800, 0) do |e|
        raise e if e

        heartbeat.close {}
        producer.close {}
        stopper.close {}
      end

      begin
        loop.run
      rescue Exception => e
        abort e.message
      end
      """
    And a file named "pipe_consumer_example.rb" with:
      """
      require 'uvrb'

      loop = UV::Loop.default

      pipe     = File.open("/tmp/exchange-pipe.pipe", File::RDWR|File::NONBLOCK)
      consumer = loop.pipe

      consumer.open(pipe.fileno)

      consumer.start_read do |e, workload|
        raise e if e

        puts "received #{workload}"
      end

      stopper = loop.timer

      stopper.start(2000, 0) do |e|
        raise e if e

        consumer.close {}
        stopper.close {}
      end

      begin
        loop.run
      rescue Exception => e
        abort e.message
      end
      """
    When I run `ruby pipe_producer_example.rb` interactively
    And I run `ruby pipe_consumer_example.rb`
    Then the output should contain consumed workload