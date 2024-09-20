require 'forwardable'

module Kredki
  module Context
    class Joystick
      extend Forwardable

      model :action, :joystick

      def buttons *input
        input.flatten.map{ @joystick.button(_1).to_i }.uniq
      end

      def axes *input
        input.flatten.map{ @joystick.axis(_1).to_i }.uniq
      end

      aliasing def on_button! ...
        @action.on_joystick_button_down!(self, ...)
      end, :on_button_down!

      def on_button_up! ...
        @action.on_joystick_button_up!(self, ...)
      end

      def on_axis! ...
        @action.on_joystick_axis!(self, ...)
      end

      def_delegators :@joystick,
        :down?,
        :value

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
  end
end