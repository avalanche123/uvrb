Feature: Named pipes

  Unix domain sockets and named pipes are useful for inter-process communication.

  Scenario: bidirectional inter process communication
    Given a file named "ipc_server_example.rb" with:
      """
      require 'uvrb'

      pong = "pong"
      loop = UV::Loop.default

      server  = loop.pipe
      clients = []

      server.bind("/tmp/ipc-example.ipc")
      server.listen(128) do |e|
        raise e if e

        clients << client = server.accept

        client.start_read do |e, ping|
          raise e if e

          client.write(pong) { |e| raise e if e }
        end
      end

      server_stopper = loop.timer

      server_stopper.start(2800, 0) do |e|
        raise e if e

        clients.each do |client|
          client.close {}
        end
        server.close {}
        server_stopper.close {}
      end

      begin
        loop.run
      rescue Exception => e
        abort e.message
      ensure
        File.unlink("/tmp/ipc-example.ipc") if File.exists?("/tmp/ipc-example.ipc")
      end
      """
    And a file named "ipc_client_example.rb" with:
      """
      require 'uvrb'

      ping = "ping"
      loop = UV::Loop.default

      client = loop.pipe

      client.connect("/tmp/ipc-example.ipc") do |e|
        raise e if e

        pinger = loop.timer

        pinger.start(0, 200) do |e|
          raise e if e

          client.write(ping) do |e|
            raise e if e

            puts "sent #{ping} to server"
          end
        end

        client.start_read do |e, pong|
          raise e if e

          puts "received #{pong} from server"
        end
      end

      client_stopper = loop.timer
      client_stopper.start(2000, 0) do |e|
        raise e if e
        
        client.close {}
        client_stopper.close {}
      end

      begin
        loop.run
      rescue UV::Error::EOF, UV::Error::EBADF => e
        exit 0
      rescue Exception => e
        abort e.message
      ensure
        File.unlink("/tmp/ipc-example.ipc") if File.exists?("/tmp/ipc-example.ipc")
      end
      """
    When I run `ruby ipc_server_example.rb` interactively
    And I run `ruby ipc_client_example.rb`
    Then the output should contain ping pong exchange

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