Gem::Specification.new do |gem|
  gem.name = "http_tracker"
  gem.version = "0.1.0"
  gem.authors = ["Dalto Curvelano Junior"]
  gem.summary = "A simple and modular rack middleware to track http requests"
  gem.license = "MIT"
  gem.homepage = "http://github.com/dlt/request_tracker"

  gem.files = Dir.glob("{lib}/**/*")
  gem.test_files = Dir.glob("{spec,examples}/**/*")

  gem.add_dependency "rack"
  gem.add_development_dependency "rspec"
end
