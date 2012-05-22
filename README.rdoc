# uv.rb - libuv FFI bindings for Ruby

[Libuv](https://github.com/joyent/libuv) is a cross platform asynchronous IO implementation that powers NodeJS. It supports sockets, both UDP and TCP, filesystem operations, TTY, Pipes and other asynchronous primitives like timer, check, prepare and idle.

UV.rb is FFI Ruby bindings for libuv.

## Usage

Create a uv loop or use a default one

```ruby
require 'uv'

loop = UV::Loop.default
# or
# loop = UV::Loop.new

timer = loop.timer
timer.start(50000, 0) do |error|
  p error if error
  puts "50 seconds passed"
  timer.close
end

loop.run
```

Find more examples in examples directory

## Installation

```shell
gem install uvrb
```

or

```shell
git clone ...
cd ...
bundle install
```

Make sure you have libuv compiled and a .dylib file available in your
lib path.

To compile libuv with .dylib, you can install provided Homebrew formula
by running:

```shell
brew install Formula/libuv.rb --HEAD --with-dylib
```


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