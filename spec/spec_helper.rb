path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require "rubygems"
require "request_tracker"
require "rspec"
require "pp"
require "rack"

Dir[File.join(File.dirname(__FILE__), "helpers", "**/*.rb")].each do |f|
  require f
end

include RequestTracker

Rspec.configure do |config|
  config.include(RequestTracker::Spec::Helpers)
end
