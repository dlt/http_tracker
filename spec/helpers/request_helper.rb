module RequestTracker::Spec
  module Helpers

    # Stolen from Warden http://github.com/hassox/warden
    def env_with_params(path = "/", params = {}, env = {})
      method = params.delete(:method) || "GET"
      env = { 'HTTP_VERSION' => '1.1', 'REQUEST_METHOD' => "#{method}" }.merge(env)
      Rack::MockRequest.env_for("#{path}?#{Rack::Utils.build_query(params)}", env)
    end

    def basic_app
      lambda  do |env|
        [200, { "Content-Type" => "text/html" }, "yes!"] 
      end
    end

    def setup_rack(middleware_class, options = {}, &block)
      app ||= block_given? ? block : basic_app
      Rack::Builder.new do
        use middleware_class, options
        run app
      end
    end

  end
end
