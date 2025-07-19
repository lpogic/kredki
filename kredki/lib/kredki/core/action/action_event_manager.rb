require_relative '../event/event_manager'
require_relative '../event/keyboard_event_manager'
require_relative '../event/mouse_event_manager'
require_relative '../event/joystick_event_manager'

module Kredki
  class ActionEventManager

    model do
      @managers = {}
    end

    def manager event_type, block, always = false
      manager = (@managers[event_type] ||= EventManager.new)
      block ? manager.attach!(block, always:) : manager
    end

    def keyboard_manager event_type, keycodes, block, always = false
      manager = (@managers[event_type] ||= KeyboardEventManager.new)[*keycodes]
      block ? manager.attach!(block, always:) : manager
    end

    def mouse_manager event_type, indexes, block, always = false
      manager = (@managers[event_type] ||= MouseEventManager.new)[*indexes]
      block ? manager.attach!(block, always:) : manager
    end
    
    def joystick_manager event_type, joystick, indexes, block, always = false
      manager = (@managers[event_type] ||= JoystickEventManager.new)[joystick, indexes]
      block ? manager.attach!(block, always:) : manager
    end

    def resolve event
      @managers[event.class]&.resolve event
    end
  end
end