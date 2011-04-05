path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require "rubygems"
require "http_tracker"
require "rspec"
require "rack"
require "pp"

Dir[File.join(File.dirname(__FILE__), "helpers", "**/*.rb")].each do |f|
  require f
end

include HTTPTracker

Rspec.configure do |config|
  config.include(HTTPTracker::Spec::Helpers)
end
