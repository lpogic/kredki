module Kredki
  class EventAccumulator

    class Entry
      struct :target, :event

      def release
        @target.event @event, true
      end
    end

    model do
      @loaded = nil
    end

    def load &block
      loaded, @loaded = @loaded, []
      block.call
      result = release
      @loaded = loaded
      result
    end

    def store target, event
      return false if !@loaded
      @loaded << Entry.new(target, event)
      return true
    end

    def release
      return 0 if !@loaded || @loaded.empty?
      loaded, @loaded = @loaded, []
      result = loaded.sum(&:release) + release
      @loaded = nil
      result
    end

  end
end