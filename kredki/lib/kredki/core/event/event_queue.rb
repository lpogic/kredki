module Kredki
  # Responsible for the order in which events are reported.
  class EventQueue

    # :section: LEVEL 2

    # The maximum number of reported events in one call, before EventQueue switch to loop safe mode.
    EVENT_LOOP_SAFE_THRESHOLD = 500

    def initialize
      @stops = []
      @stem = false
      @i = -1
    end

    def inspect
      "#{self.class}:#{object_id}"
    end

    def push event, stop, early = false, instant = false
      if instant
        @stops[@i += 1] = [stop, event, early]
      else
        @stops << [stop, event, early]
      end
      process if !@stem
    end

    def process
      stem, @stem = @stem, true
      (0..).each do |i|
        @i = i
        if i > EVENT_LOOP_SAFE_THRESHOLD
          begin
            return loop_safe_report i
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
        stop, event, early = *stop
        stop.report event, early
      end
    end

    private

    class EventLoopError < Exception
    end

    def loop_error range
      raise EventLoopError.new "#{@stops[range]}"
    end

    def loop_safe_report start = 0
      proceed = {}
      (start..).each do |i|
        @i = i
        return unless stop = @stops[i]
        if j = proceed[stop]
          loop_error j..i
        else
          proceed[stop] = i
        end
        stop, event, early = *stop
        stop.report event, early
      end
    end

  end
end