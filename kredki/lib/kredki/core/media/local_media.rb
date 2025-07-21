require_relative 'local/mouse'
require_relative 'local/keyboard'
require_relative 'local/joystick'

module Kredki
  module LocalMedia

    def mouse &block
      m = Mouse.new self, Kredki.mouse
      m.instance_exec &block if block
      m
    end

    def keyboard &block
      k = Keyboard.new self, Kredki.keyboard
      k.instance_exec &block if block
      k
    end

    def joystick param = nil, &block
      joystick = case param
      when Joystick
        param
      when Kredki::Joystick
        Joystick.new self, param
      else
        j = Kredki.joystick param
        raise "Joystick #{param} not found" if !j
        Joystick.new self, j
      end
      joystick.instance_exec &block if block
      joystick
    end

    def clipboard
      Kredki.clipboard
    end
  end
end