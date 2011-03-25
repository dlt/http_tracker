Gem::Specification.new do |gem|
  gem.name = "request_tracker"
  gem.version = "0.0.1"
  gem.authors = ["Dalto Curvelano Junior"]
  gem.summary = "A simple and modular rack middleware to track http requests"
  gem.license = 'MIT'
  gem.homepage = "http://github.com/dlt/request_tracker"

  gem.files = Dir.glob("{lib}/**/*")
  gem.test_files = Dir.glob("{spec}/**/*")

  gem.require_path = 'lib'

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "fakeweb"
end
