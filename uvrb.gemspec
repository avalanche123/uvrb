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

  gem.required_ruby_version = '>= 1.9.2'
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency     'ffi', '~> 1.9'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'cucumber', '~> 1.3'
  gem.add_development_dependency 'aruba', '~> 0.5'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rdoc', '~> 4.0'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  relative_path = File.expand_path("../", __FILE__) + '/'
  `git submodule --quiet foreach pwd`.split($\).each do |submodule_path|

    if (ENV['OS'] == 'Windows_NT') && submodule_path[0] == '/'
      # Detect if cygwin path is being used by git
      submodule_path = submodule_path[1..-1]
      submodule_path.insert(1, ':')
    end

    # for each submodule, change working directory to that submodule
    Dir.chdir(submodule_path) do
      # Make the submodule path relative
      submodule_path = submodule_path.gsub(/#{relative_path}/i, '')
 
      # issue git ls-files in submodule's directory
      submodule_files = `git ls-files`.split($\)
 
      # prepend the submodule path to create relative file paths
      submodule_files_paths = submodule_files.map do |filename|
        File.join(submodule_path, filename)
      end
 
      # add relative paths to gem.files
      gem.files += submodule_files_paths
    end
  end
end
