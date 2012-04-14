require 'socket'
require 'thread'
require 'timeout'

server = TCPServer.new(10000)
server.listen(128)

Timeout.timeout(50) do
  while(client = server.accept)
    client.puts "HTTP/1.1 200 OK\r\n"
    client.puts "Content-Type: text/plain\r\n"
    client.puts "Content-Length: 12\r\n"
    client.puts "\r\n"
    client.puts "hello world\n"
    client.close
    client = nil
  end
end

