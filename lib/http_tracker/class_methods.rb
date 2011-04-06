module HTTPTracker
  module ClassMethods
    def add(label, klass = nil, &block)
      if label.is_a?(Class) || (klass.nil? && !block_given?)
        raise ArgumentError,
          "A class or a block should be passed along with the tracker label."
      end

      klass ||= Class.new
      if block_given?
        klass.class_eval(&block)
      end

      tracker = klass.new

      if !tracker.respond_to?(:on_request) && !tracker.respond_to?(:on_response)
        raise ArgumentError,
          "You should implement one of the following methods: on_response, on_request."
      end

      trackers[label] = klass
    end

    def trackers
      @trackers ||= {}
    end

    def clear!
      @trackers = {}
    end
  end
end
