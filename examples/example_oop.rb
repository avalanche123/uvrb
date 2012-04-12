require 'rubygems'
require 'bundler/setup'
require 'uvrb'

start = Time.now

loop = UV::Loop.default

count = 0
timer = loop.timer
$stdout << "\r\n"

timer.start(1, 1) do |status|
  $stdout << "\r#{count}"
  if count >= 10000
    timer.close do
      $stdout << "\n"
    end
  end
  count += 1
end

loop.run
$stdout << "\n"

puts Time.now - start
