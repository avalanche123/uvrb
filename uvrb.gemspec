require File.expand_path("../lib/uv/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "uvrb"
  gem.version       = UV::VERSION
  gem.license       = 'MIT'
  gem.authors       = ["Bulat Shakirzyanov"]
  gem.email         = ["mallluhuct@gmail.com"]
  gem.homepage      = "http://avalanche123.github.com/uvrb"
  gem.summary       = "libuv bindings for Ruby"
  gem.description   = "UV is Ruby OOP bindings for libuv"

  gem.requirements << 'libuv'
  gem.extensions << "ext/Rakefile"

  gem.required_ruby_version = '>= 1.9.2'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency     'ffi', '~> 1.9'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'cucumber', '~> 1.3'
  gem.add_development_dependency 'aruba', '~> 0.5'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rdoc', '~> 4.0'
end
