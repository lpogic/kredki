module Kredki
  class JoystickEventCallings
    model do
      @callings = {}
    end

    def call event
      (@callings.dig(event.joystick, event.input_id)&.call(event) || 0) +
      (@callings.dig(event.joystick, nil)&.call(event) || 0) +
      (@callings.dig(nil, nil)&.call(event) || 0)
    end

    def [](*indexes, joystick: nil)
      callings = @callings[joystick] ||= {}
      case indexes.size
      when 0
        callings[nil] ||= EventCallings.new
      when 1
        callings[indexes.first] ||= EventCallings.new
      else
        CompositeEventCallings.new indexes.map{ callings[_1] ||= EventCallings.new }
      end
    end
  end
end