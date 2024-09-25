module Kredki
  class JoystickEventManager
    model do
      @managers = {}
    end

    def resolve event
      @managers.dig(event.joystick, event.input_id)&.resolve event
      @managers.dig(event.joystick, nil)&.resolve event
      @managers.dig(nil, nil)&.resolve event
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