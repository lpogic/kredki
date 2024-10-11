module Kredki
  class EventDirector

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
        pair = @pairs[i]
        break unless pair
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
      @pairs = []
      @stem = stem
    end

  end
end