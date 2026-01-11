require_relative 'composite_event_manager'

module Kredki
  # Manage keyboard event managerseactions.
  class KeyboardEventManager

    # :section: LEVEL 2

    def initialize
      @managers = {}
    end

    def report event
      @managers[event.input_id]&.report event
      @managers[nil]&.report event
    end

    def [](*keycodes)
      case keycodes.size
      when 0
        @managers[nil] ||= EventManager.new
      when 1
        @managers[keycodes.first] ||= EventManager.new
      else
        CompositeEventManager.new keycodes.map{ @managers[_1] ||= EventManager.new }
      end
    end
  end
end