require 'rubygems'
require 'bundler/setup'
require 'uvrb'

loop = UV::Loop.default

stdin = loop.tty($stdin, true)
stdin.enable_raw_mode
stdin.start_read do |data|
  $stdout << data
end

stoper = loop.timer
stoper.start(25000, 0) do
  puts "25 seconds passed"
  stdin.close
  stoper.close
end

loop.run
