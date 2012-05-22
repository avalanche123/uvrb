Feature: named pipes

  Named pipes are a special type of file used in inter process communication on UNIX
  systems

  Scenario: inter process communication
    Given a file named "pipe_server_example.rb" with:
      """
      require 'uvrb'

      pong = "pong"
      loop = UV::Loop.default

      server  = loop.pipe(true)

      server.bind("/tmp/pipe-example.ipc")
      server.listen(128) do |e|
        raise e if e

        client = server.accept

        client.start_read do |e, ping|
          raise e if e

          client.write(pong) { |e| raise e if e }
        end

        client_timeout = loop.timer

        client_timeout.start(2000, 0) do |e|
          raise e if e

          client.close {}
          client_timeout.close {}
        end
      end

      stopper = loop.timer

      stopper.start(3000, 0) do |e|
        raise e if e

        server.close {}
        stopper.close {}
      end

      begin
        loop.run
      rescue Exception => e
        abort e.message
      end
      """
    And a file named "pipe_client_example.rb" with:
      """
      require 'uvrb'

      ping = "ping"
      loop = UV::Loop.default

      client = loop.pipe(true)

      client.connect("/tmp/pipe-example.ipc") do |e|
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

      begin
        loop.run
      rescue UV::Error::EOF => e
        exit 0
      rescue Exception => e
        abort e.message
      end
      """
    When I run `ruby pipe_server_example.rb` interactively
    And I run `ruby pipe_client_example.rb`
    Then the output should contain ping pong exchange