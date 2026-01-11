require_relative '../event/event_manager'
require_relative '../event/keyboard_event_manager'
require_relative '../event/mouse_event_manager'
require_relative '../event/joystick_event_manager'

module Kredki
  # Manage window scene events.
  class WindowSceneEventManager

    # :section: LEVEL 2

    def initialize
      @managers = {}
    end

    def manager event_type, reaction, always = false
      manager = (@managers[event_type] ||= EventManager.new)
      reaction ? manager.attach(reaction, always:) : manager
    end

    def keyboard_manager event_type, keycodes, reaction, always = false
      manager = (@managers[event_type] ||= KeyboardEventManager.new)[*keycodes]
      reaction ? manager.attach(reaction, always:) : manager
    end

    def mouse_manager event_type, buttoncodes, reaction, always = false
      manager = (@managers[event_type] ||= MouseEventManager.new)[*buttoncodes]
      reaction ? manager.attach(reaction, always:) : manager
    end
    
    def joystick_manager event_type, joystick, indexes, reaction, always = false
      manager = (@managers[event_type] ||= JoystickEventManager.new)[joystick, indexes]
      reaction ? manager.attach(reaction, always:) : manager
    end

    def report event
      @managers[event.class]&.report event
    end
  end
end