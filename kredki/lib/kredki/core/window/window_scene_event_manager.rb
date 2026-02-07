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

    def keyboard_manager event_type, codes, reaction, always = false
      manager = (@managers[event_type] ||= KeyboardEventManager.new)[*codes]
      reaction ? manager.attach(reaction, always:) : manager
    end

    def mouse_manager event_type, codes, reaction, always = false
      manager = (@managers[event_type] ||= MouseEventManager.new)[*codes]
      reaction ? manager.attach(reaction, always:) : manager
    end
    
    def joystick_manager event_type, joystick, codes, reaction, always = false
      manager = (@managers[event_type] ||= JoystickEventManager.new)[joystick, codes]
      reaction ? manager.attach(reaction, always:) : manager
    end

    def report event
      cl = event.class
      while cl != Object
        @managers[cl]&.report event
        cl = cl.superclass
      end
    end
  end
end