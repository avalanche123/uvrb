require 'rubygems'
require 'bundler/setup'
require 'uvrb'

loop = UV::Loop.default

client = loop.tcp

client.connect("127.0.0.1", 10000) do |err|
  if err
    p err
    exit 1
  end
  client.write("GET /\r\nHost: localhost:10000\r\nAccept: *\r\n\r\n\n") do |err|
    if err
      p err
      exit 1
    end
    client.start_read do |data, err|
      if err
        p err
        exit 1
      end
      puts data
      client.close
    end
  end
  # client.close
end

loop.run