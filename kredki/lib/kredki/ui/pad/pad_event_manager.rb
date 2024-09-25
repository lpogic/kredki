require 'kredki-core/event/event_manager'
require 'kredki-core/event/keyboard_event_manager'
require 'kredki-core/event/mouse_event_manager'
require 'kredki-core/event/joystick_event_manager'

module Kredki
  class PadEventManager

    def self.mode_map mode
      case mode
      when :default
        :alt
      when :resolved
        :alt_resolved
      else
        mode
      end
    end

    model do
      @managers = {
        alt: {},
        aim: {},
        alt_resolved: {},
        aim_resolved: {},
      }
    end

    def manager event_type, block, mode = :default
      manager = (@managers[PadEventManager.mode_map mode][event_type] ||= EventManager.new)
      block ? manager.attach!(block) : manager
    end

    def keyboard_manager event_type, keycodes, block, mode = :default
      manager = (@managers[PadEventManager.mode_map mode][event_type] ||= KeyboardEventManager.new)[*keycodes]
      block ? manager.attach!(block) : manager
    end

    def mouse_manager event_type, indexes, block, mode = :default
      manager = (@managers[PadEventManager.mode_map mode][event_type] ||= MouseEventManager.new)[*indexes]
      block ? manager.attach!(block) : manager
    end
    
    def joystick_manager event_type, joystick, indexes, block, mode = :default
      manager = (@managers[PadEventManager.mode_map mode][event_type] ||= JoystickEventManager.new)[joystick, indexes]
      block ? manager.attach!(block) : manager
    end

    def resolve event, mode = :default
      @managers[PadEventManager.mode_map mode][event.class]&.resolve event
    end
  end
end