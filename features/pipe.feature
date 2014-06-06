Feature: Named pipes

  Unix domain sockets and named pipes are useful for inter-process communication.

  Scenario: a client and server exchange pings and pongs over a pipe
    Given a file named "ipc_server_example.rb" with:
      """
      require 'uvrb'

      pong = "pong"
      loop = UV::Loop.default

      server  = loop.pipe

      server.bind("/tmp/ipc-example.ipc")
      server.listen(128) do |e|
        raise e if e

        client = server.accept

        client.start_read do |e, data|
          raise e if e

          client.write(pong) do |e|
            raise e if e

            client.close {}
            server.close {}
          end
        end
      end

      stopper = loop.timer
  
      stopper.start(5000, 0) do |e|
        raise e if e
  
        server.close {}
        stopper.close {}
      end

      begin
        loop.run
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

        client.start_read do |e, pong|
          raise e if e

          puts "received #{pong} from server"

          client.close {}
        end

        client.write(ping) do |e|
          raise e if e

          puts "sent #{ping} to server"
        end
      end

      begin
        loop.run
      rescue UV::Error::EOF, UV::Error::EBADF => e
        exit 0
      end
      """
    When I run `ruby ipc_server_example.rb` interactively
    And I wait for 1 seconds
    And I run `ruby ipc_client_example.rb`
    Then the output should contain ping pong exchange
