module Kredki
  class EventDirector

    EVENT_LOOP_LIMIT = 200

    model do
      @pairs = []
      @stem = false
    end

    def stem &block
      stem, @stem = @stem, true
      block.call
      @stem = stem
      resolve if !@stem
    end

    def inspect
      "#{self.class}:#{object_id}"
    end

    def push event, target, mode
      @pairs << [event, target, mode]
      resolve if !@stem
    end

    def push_block event, &block
      @pairs << [event, block]
    end

    def resolve
      stem, @stem = @stem, true
      (0..).each do |i|
        if i > EVENT_LOOP_LIMIT
          begin
            return loop_safe_resolve i
          ensure
            @pairs = []
            @stem = stem
          end
        end
        pair = @pairs[i]
        unless pair
          @pairs = []
          @stem = stem
          return
        end
        event, target, mode = *pair
        if target.is_a? Proc
          target.call event
        else
          mode = case mode
          when :alt
            event.resolved? ? :alt_resolved : :alt
          when :aim
            event.resolved? ? :aim_resolved : :aim
          else
            mode
          end
          target.resolve event, mode
        end
      end
    end

    private

    class EventLoopError < Exception
    end

    def loop_error range
      raise EventLoopError.new "#{@pairs[range]}"
    end

    def loop_safe_resolve start = 0
      proceed = {}
      (start..).each do |i|
        return unless pair = @pairs[i]
        if j = proceed[pair]
          loop_error j..i
        else
          proceed[pair] = i
        end
        event, target, mode = *pair
        if target.is_a? Proc
          target.call event
        else
          mode = case mode
          when :alt
            event.resolved? ? :alt_resolved : :alt
          when :aim
            event.resolved? ? :aim_resolved : :aim
          else
            mode
          end
          target.resolve event, mode
        end
      end
    end

  end
end