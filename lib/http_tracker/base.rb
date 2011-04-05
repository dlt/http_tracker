module HTTPTracker
  class Manager
    extend ClassMethods

    def initialize(app, options = {})
      @app, @options = app, options
    end

    def call(env)
      run_before_callbacks!(env)
      
      status, headers, body = @app.call(env)
      
      run_after_callbacks!(env, status, headers, body)

      [status, headers, body]
    end

    def initialize_trackers!
      trackers.each_pair do |label, tracker_klass|
        trackers[label] = tracker_klass.new
      end
    end

    private
      def trackers
        self.class.trackers
      end

      def run_before_callbacks!(env)
        initialize_trackers!
        run_callbacks(:before, env)
      end

      def run_after_callbacks!(env, status, headers, body)
        run_callbacks(:after, env, status, headers, body)
      end

      def run_callbacks(name, *args)
        env = args.first
        trackers.each_pair do |label, tracker|
          method = "#{name}_call"

          if tracker.valid?(env) && tracker.respond_to?(method)
            tracker.send("#{name}_call", *args)
          end
        end
      end
  end
end
