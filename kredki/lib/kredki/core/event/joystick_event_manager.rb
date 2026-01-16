module Kredki
  # Manage joystick event managers.
  class JoystickEventManager

    # :section: LEVEL 2

    def initialize
      @managers = {}
    end

    def report event
      @managers.dig(event.joystick, event.input_id)&.report event
      @managers.dig(event.joystick, nil)&.report event
      @managers.dig(nil, event.input_id)&.report event
      @managers.dig(nil, nil)&.report event
    end

    def [](joystick, indexes)
      managers = @managers[joystick] ||= {}
      case indexes.size
      when 0
        managers[nil] ||= EventManager.new
      when 1
        managers[indexes.first] ||= EventManager.new
      else
        CompositeEventManager.new indexes.map{ managers[_1] ||= EventManager.new }
      end
    end
  end
end