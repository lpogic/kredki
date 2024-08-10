require_relative '../keyboard'
require_relative 'event'
require_relative 'composite_event_callings'

module Kredki
  class KeyboardEventCallings
    def initialize
      @callings = {}
    end

    def call event
      (@callings[event.keycode]&.call(event) || 0) + (@callings[nil]&.call(event) || 0)
    end

    def [](*keycodes)
      case keycodes.size
      when 0
        @callings[nil] ||= EventCallings.new
      when 1
        @callings[keycodes.first] ||= EventCallings.new
      else
        CompositeEventCallings.new keycodes.map{ @callings[_1] ||= EventCallings.new }
      end
    end
  end
end