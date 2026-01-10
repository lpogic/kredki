module Kredki
  # Event manager for Service.
  class ServiceEventManager

    # :section: LEVEL 2

    def initialize
      @managers = {
        true => {},
        false => {},
      }
    end

    def manager event_class, block, early, always
      manager = (@managers[early][event_class] ||= EventManager.new)
      block ? manager.attach!(block, always:) : manager
    end

    def keyboard_manager event_class, keycodes, block, early, always
      manager = (@managers[early][event_class] ||= KeyboardEventManager.new)[*keycodes]
      block ? manager.attach!(block, always:) : manager
    end

    def mouse_manager event_class, indexes, block, early, always
      manager = (@managers[early][event_class] ||= MouseEventManager.new)[*indexes]
      block ? manager.attach!(block, always:) : manager
    end
    
    def joystick_manager event_class, joystick, indexes, block, early, always
      manager = (@managers[early][event_class] ||= JoystickEventManager.new)[joystick, indexes]
      block ? manager.attach!(block, always:) : manager
    end

    def resolve event, early
      cl = event.class
      manager = @managers[early]
      while cl != Object
        manager[cl]&.resolve event
        cl = cl.superclass
      end
    end
  end
end