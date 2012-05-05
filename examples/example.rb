require 'rubygems'
require 'bundler/setup'
require 'uvrb'

start = Time.now

loop = UV.default_loop

timer = UV.create_handle(:uv_timer)
# timer = FFI::MemoryPointer.new(UV::Timer, UV::Timer.size, 1)
count = 0
UV.timer_init(loop, timer)
$stdout << "\r\n"

close_cb = proc {|ptr| UV.free(ptr); $stdout << "\n"; }

timer_cb = Proc.new do |ptr, status|
  $stdout << "#{count}\r"
  if count >= 10000
    UV.close(ptr, close_cb)
  end
  count += 1
end

UV.timer_start(timer, timer_cb, 1, 1)
UV.run(loop)
UV.loop_delete(loop)

puts Time.now - start
