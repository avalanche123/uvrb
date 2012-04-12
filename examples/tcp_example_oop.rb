require 'rubygems'
require 'bundler/setup'
require 'uvrb'

loop = UV::Loop.default

server = loop.tcp

server.bind("0.0.0.0", 10000)

server.listen(128) do |status|
  client = server.accept

  client.start_read do |data, e|
    if e
      p e
      client.close
    end
    client.stop_read
    client.write("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 12\r\n\r\nhello world\n") do |e|
      if e
        p e
      end
      client.close
    end
  end
end

stoper = loop.timer
stoper.start(50000, 0) do
  puts "50 seconds passed"
  server.close
  stoper.close
end

loop.run
