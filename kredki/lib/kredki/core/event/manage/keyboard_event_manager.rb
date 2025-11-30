require_relative 'composite_event_manager'

module Kredki
  class KeyboardEventManager
    def initialize
      @resolvers = {}
    end

    def resolve event
      @resolvers[event.input_id]&.resolve event
      @resolvers[nil]&.resolve event
    end

    def [](*keycodes)
      case keycodes.size
      when 0
        @resolvers[nil] ||= EventManager.new
      when 1
        @resolvers[keycodes.first] ||= EventManager.new
      else
        CompositeEventManager.new keycodes.map{ @resolvers[_1] ||= EventManager.new }
      end
    end
  end
end