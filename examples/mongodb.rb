require "rubygems"
require "http_tracker"
require "sinatra"
require "pp"
require "mongo"

class MongoTracker
  include Mongo

  def valid?(env); true; end

  def on_request(env)
    storage.save \
      "ip" => env["REMOTE_ADDR"],
      "path_info" => env["PATH_INFO"],
      "method" => env["REQUEST_METHOD"]
  end

  def on_response(env, status, headers, body)
    puts "Total requests made: #{storage.count}" 
  end

  private
    def storage
      @storage ||= begin
        db_name, collection_name = "http_tracker_examples", "test"

        connection = Connection.new.db(db_name)
        unless connection.collection_names.include?(collection_name)
          connection.create_collection(collection_name)
        end

        connection.collection(collection_name)
      end
    end
end

HTTPTracker::Manager.add(:mongo, MongoTracker)

use HTTPTracker::Manager

get "/foo" do
  ":-)"
end


