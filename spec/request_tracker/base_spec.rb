require 'spec_helper'

describe Base do

  it "should do it" do
    setup_rack(RequestTracker::Base).call(env_with_params)
  end
end
