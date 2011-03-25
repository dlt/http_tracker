require 'spec_helper'

describe Base do

  before do
    @app = Rack::Builder.new do
      lambda { |app| [200, { :"Content-Type" => "text/html" }, "BODY"] }
    end
  end
end
