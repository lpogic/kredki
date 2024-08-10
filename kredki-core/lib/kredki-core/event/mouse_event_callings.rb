module Kredki
  class MouseEventCallings
    model do
      @callings = {}
    end

    def call event
      (@callings[event.button]&.call(event) || 0) + (@callings[nil]&.call(event) || 0)
    end

    def [](*indexes)
      case indexes.size
      when 0
        @callings[nil] ||= EventCallings.new
      when 1
        @callings[indexes.first] ||= EventCallings.new
      else
        CompositeEventCallings.new indexes.map{ @callings[_1] ||= EventCallings.new }
      end
    end
  end
end