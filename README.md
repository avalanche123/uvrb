# uv.rb - Ruby bindings for libuv

Create a uv loop or use a default one

```ruby
require 'uv'

loop = UV::Loop.default
# or
loop = UV::Loop.new

loop.run
loop.once
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
