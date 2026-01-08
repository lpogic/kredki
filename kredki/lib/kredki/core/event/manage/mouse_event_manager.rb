module Kredki
  # Manage mouse events resolving.
  class MouseEventManager

    # :section: LEVEL 2

    def initialize
      @resolvers = {}
    end

    def resolve event
      id = event.input_id and @resolvers[id]&.resolve event
      @resolvers[nil]&.resolve event
    end

    def [](*ids)
      case ids.size
      when 0
        @resolvers[nil] ||= EventManager.new
      when 1
        @resolvers[ids.first] ||= EventManager.new
      else
        CompositeEventManager.new ids.map{ @resolvers[it] ||= EventManager.new }
      end
    end
  end
end