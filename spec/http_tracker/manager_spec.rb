require 'spec_helper'

describe Manager do
  after do
    HTTPTracker::Manager.clear!
  end

  context "when adding new trackers" do
    it "should be able to add trackers passing blocks" do
      HTTPTracker::Manager.add(:foo) do
        def valid?; end
        def on_request; end
        def on_response; end
      end

      HTTPTracker::Manager.trackers.should have(1).trackers
      klass = HTTPTracker::Manager.trackers[:foo]

      tracker = klass.new
      tracker.respond_to?(:valid?).should be_true
      tracker.respond_to?(:on_request).should be_true
      tracker.respond_to?(:on_response).should be_true
    end

    it "should be able to add trackers using classes" do
      klass = Class.new do
        def valid?; end
        def on_request; end
        def on_response; end
      end
      HTTPTracker::Manager.add(:foo, klass)

      klass = HTTPTracker::Manager.trackers[:foo]

      tracker = klass.new
      tracker.respond_to?(:valid?).should be_true
      tracker.respond_to?(:on_request).should be_true
      tracker.respond_to?(:on_response).should be_true
    end

    it "should raise an error if a name and a class aren't provided" do
      lambda {
        HTTPTracker::Manager.add(Class.new)
      }.should raise_error

      lambda {
        HTTPTracker::Manager.add("foo")
      }.should raise_error
    end

    it "it should make the #valid? method obligatory" do
      lambda {
        HTTPTracker::Manager.add(:foo) do
          def valid?; end
        end
      }.should raise_error
    end

    it "should be obligatory to implement on of the following methods: #on_request, #on_response" do
      lambda {
        HTTPTracker::Manager.add(:foo) do
          def valid?; end
          def on_request; end
        end
      }.should_not raise_error

      lambda {
        HTTPTracker::Manager.add(:foo) do
          def valid?; end
          def on_response; end
        end
      }.should_not raise_error

    end
  end

  context "when processing a request" do
    before do
      HTTPTracker::Manager.add(:foo) do
        def valid?(env)
          true
        end

        def on_request(env)
          @x = 5
        end

        def on_response(env, status, headers, body)
          @y = 10
        end
      end

      HTTPTracker::Manager.add(:invalid) do
        def valid?(env)
          false
        end

        def on_request(env)
          @NOT = 666
        end

        def on_response(env, status, headers, body)
          @SHOULD_NOT_BE_SET = "SERIOUSLY"
        end
      end

      @app = setup_rack(HTTPTracker::Manager)
    end

    context "when in middle of resquests" do
      it "should initialize its trackers before processing the request" do
        foo_tracker = HTTPTracker::Manager.trackers[:foo]

        [:valid?, :on_request, :on_response].each do |method|
          foo_tracker.respond_to?(method).should be_false
        end

        @app.call(env_with_params)
        
        foo_tracker = HTTPTracker::Manager.trackers[:foo]
        [:valid?, :on_request, :on_response].each do |method|
          foo_tracker.respond_to?(method).should be_true
        end
      end

      it "should never initialize its trackers more than once"

    end

    it "should should run its before callbacks before processing the request" do
      @app.call(env_with_params)
      foo_tracker = HTTPTracker::Manager.trackers[:foo]
      foo_tracker.instance_variable_get("@x").should == 5
    end

    it "should should run its after callbacks before processing the request" do
      @app.call(env_with_params)
      foo_tracker = HTTPTracker::Manager.trackers[:foo]
      foo_tracker.instance_variable_get("@y").should == 10
    end

    it "should only execute the callbacks if the tracker is valid the environment" do
      @app.call(env_with_params)
      invalid_tracker = HTTPTracker::Manager.trackers[:invalid]
      invalid_tracker.instance_variable_get("@SHOULD_NOT_BE_SET").should be_nil
    end

  end
end
