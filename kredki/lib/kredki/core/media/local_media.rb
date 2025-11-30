require_relative 'local/mouse'
require_relative 'local/keyboard'
require_relative 'local/joystick'

module Kredki
  module LocalMedia

    def mouse &block
      Mouse.new(self, Kredki.mouse).alter &block
    end

    def keyboard &block
      Keyboard.new(self, Kredki.keyboard).alter &block
    end

    def joystick param = nil, &block
      case param
      when Joystick
        param
      when Kredki::Joystick
        Joystick.new self, param
      else
        j = Kredki.joystick param
        raise "Joystick #{param} not found" if !j
        Joystick.new self, j
      end.alter &block
    end

    def clipboard
      Kredki.clipboard
    end
  end
end