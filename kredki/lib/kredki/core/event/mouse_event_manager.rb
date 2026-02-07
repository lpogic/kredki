module Kredki
  # Manage mouse events managers.
  class MouseEventManager

    # :section: LEVEL 2

    def initialize
      @managers = {}
    end

    def report event
      id = event.code and @managers[id]&.report event
      @managers[nil]&.report event
    end

    def [](*ids)
      case ids.size
      when 0
        @managers[nil] ||= EventManager.new
      when 1
        @managers[ids.first] ||= EventManager.new
      else
        CompositeEventManager.new ids.map{|it| @managers[it] ||= EventManager.new }
      end
    end
  end
end