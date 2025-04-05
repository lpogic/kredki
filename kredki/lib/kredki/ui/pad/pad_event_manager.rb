require 'kredki-core/event/event_manager'
require 'kredki-core/event/keyboard_event_manager'
require 'kredki-core/event/mouse_event_manager'
require 'kredki-core/event/joystick_event_manager'

module Kredki
  class PadEventManager

    model do
      @managers = {
        true => {},
        false => {},
      }
    end

    def manager event_class, block, aim, always
      manager = (@managers[aim][event_class] ||= EventManager.new)
      block ? manager.attach!(block, always) : manager
    end

    def keyboard_manager event_class, keycodes, block, aim, always
      manager = (@managers[aim][event_class] ||= KeyboardEventManager.new)[*keycodes]
      block ? manager.attach!(block, always) : manager
    end

    def mouse_manager event_class, indexes, block, aim, always
      manager = (@managers[aim][event_class] ||= MouseEventManager.new)[*indexes]
      block ? manager.attach!(block, always) : manager
    end
    
    def joystick_manager event_class, joystick, indexes, block, aim, always
      manager = (@managers[aim][event_class] ||= JoystickEventManager.new)[joystick, indexes]
      block ? manager.attach!(block, always) : manager
    end

    def resolve event, aim
      cl = event.class
      manager = @managers[aim]
      while cl != Object
        manager[cl]&.resolve event
        cl = cl.superclass
      end
    end
  end
end