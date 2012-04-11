# uv.rb - libuv FFI bindings for Ruby

Create a uv loop or use a default one

```ruby
require 'uv'

loop = UV::Loop.default
# or
# loop = UV::Loop.new

timer = loop.timer
timer.start(50000, 0) do
  puts "50 seconds passed"
  timer.close
end

loop.run
```

## Installation

```shell
gem install uvrb
```

Make sure you have libuv compiled and a .dylib file available in your
lib path.

To compile libuv with .dylib, you can install provided Homebrew formula
by running:

```shell
brew install Formula/libuv.rb --HEAD --with-dylib
```

## How to

find examples in examples directory

## What's supported

* TCP
* UDP
* TTY
* Pipe
* Timer
* Prepare
* Check
* Idle
* Async
* Errors

## TODO

* Port rest of libuv - ares, getaddrinfo, process, work queue, fs with events, mutexes and locks
* Tests tests tests
* Docs docs docs