module HTTPTracker
  class Manager
    extend ClassMethods

    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      run_on_request_callbacks!(env)
      
      status, headers, body = @app.call(env)
      
      run_on_response_callbacks!(env, status, headers, body)

      [status, headers, body]
    end

    private
      def initialize_trackers!
        trackers.each_pair do |label, tracker_klass|
          trackers[label] = tracker_klass.new
        end
      end

      def trackers
        self.class.trackers
      end

      def run_on_request_callbacks!(env)
        initialize_trackers!
        run_callbacks(:request, env)
      end

      def run_on_response_callbacks!(env, status, headers, body)
        run_callbacks(:response, env, status, headers, body)
      end

      def run_callbacks(name, *args)
        env = args.first
        method = "on_#{name}"

        trackers.each_pair do |label, tracker|
          if tracker.valid?(env) && tracker.respond_to?(method)
            tracker.send(method, *args)
          end
        end
      end
  end
end
