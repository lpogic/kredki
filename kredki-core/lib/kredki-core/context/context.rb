require_relative 'context_mouse'
require_relative 'context_keyboard'
require_relative 'context_joystick'

module Kredki
  module Context

    def mouse &block
      m = Mouse.new self, Kredki.mouse
      m.instance_exec &block if block
      m
    end

    def keyboard &block
      k = Action::Keyboard.new self, Kredki.keyboard
      k.instance_exec &block if block
      k
    end

    def joystick param = nil, &block
      joystick = case param
      when Joystick
        param
      when Kredki::Joystick
        Action::Joystick.new self, param
      else
        j = Kredki.joystick param
        raise "Joystick #{param} not found" if !j
        Action::Joystick.new self, j
      end
      joystick.instance_exec &block if block
      joystick
    end

    def clipboard
      Kredki.clipboard
    end

    def on! event_type, mode: :default, &block
      @event_manager.manager event_type, block, mode
    end
  end
end