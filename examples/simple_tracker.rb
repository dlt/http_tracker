require "rubygems"
require "http_tracker"
require "sinatra"
require "pp"

HTTPTracker::Manager.add(:simple) do
  def valid?(env); true; end

  def on_request(env)
    pp env
  end
end

use HTTPTracker::Manager

get "/foo" do
  ":-)"
end


