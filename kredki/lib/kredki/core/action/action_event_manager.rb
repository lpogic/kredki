require_relative '../event/manage/event_manager'
require_relative '../event/manage/keyboard_event_manager'
require_relative '../event/manage/mouse_event_manager'
require_relative '../event/manage/joystick_event_manager'

module Kredki
  class ActionEventManager

    # :section: LEVEL 2

    def initialize
      @managers = {}
    end

    def manager event_type, resolver, always = false
      manager = (@managers[event_type] ||= EventManager.new)
      resolver ? manager.attach!(resolver, always:) : manager
    end

    def keyboard_manager event_type, keycodes, resolver, always = false
      manager = (@managers[event_type] ||= KeyboardEventManager.new)[*keycodes]
      resolver ? manager.attach!(resolver, always:) : manager
    end

    def mouse_manager event_type, indexes, resolver, always = false
      manager = (@managers[event_type] ||= MouseEventManager.new)[*indexes]
      resolver ? manager.attach!(resolver, always:) : manager
    end
    
    def joystick_manager event_type, joystick, indexes, resolver, always = false
      manager = (@managers[event_type] ||= JoystickEventManager.new)[joystick, indexes]
      resolver ? manager.attach!(resolver, always:) : manager
    end

    def resolve event
      @managers[event.class]&.resolve event
    end
  end
end