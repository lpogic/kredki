module Kredki
  class EventDirector

    EVENT_LOOP_LIMIT = 200

    model do
      @stops = []
      @stem = false
      @i = -1
    end

    def stem &block
      stem, @stem = @stem, true
      block.call
      @stem = stem
      resolve if !@stem
      true
    end

    def inspect
      "#{self.class}:#{object_id}"
    end

    def push event, stop, aim = false, instant = false
      if instant
        @stops[@i += 1] = [stop, event, aim]
      else
        @stops << [stop, event, aim]
      end
      resolve if !@stem
    end

    def push_block event = nil, instant = false, &stop
      if instant
        @stops[@i += 1] = [stop, event]
      else
        @stops << [stop, event]
      end
    end

    def resolve
      stem, @stem = @stem, true
      (0..).each do |i|
        @i = i
        if i > EVENT_LOOP_LIMIT
          begin
            return loop_safe_resolve i
          ensure
            @stops = []
            @stem = stem
            @i = -1
          end
        end
        stop = @stops[i]
        unless stop
          @stops = []
          @stem = stem
          @i = -1
          return
        end
        stop, event, aim = *stop
        if stop.is_a? Proc
          stop.call event
        else
          stop.resolve event, aim
        end
      end
    end

    private

    class EventLoopError < Exception
    end

    def loop_error range
      raise EventLoopError.new "#{@stops[range]}"
    end

    def loop_safe_resolve start = 0
      proceed = {}
      (start..).each do |i|
        @i = i
        return unless stop = @stops[i]
        if j = proceed[stop]
          loop_error j..i
        else
          proceed[stop] = i
        end
        stop, event, mode = *stop
        if stop.is_a? Proc
          stop.call event
        else
          stop.resolve event, mode
        end
      end
    end

  end
end