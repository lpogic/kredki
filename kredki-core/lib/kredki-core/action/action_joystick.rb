require 'forwardable'

module Kredki
  class Action
    class Joystick
      extend Forwardable

      model :action, :joystick

      def buttons *input
        input.flatten.map{ @joystick.button(_1).to_i }.uniq
      end

      def axes *input
        input.flatten.map{ @joystick.axis(_1).to_i }.uniq
      end

      def on_button! ...
        @action.on_joystick_button_down!(self, ...)
      end

      alias_method :on_button_down!, :on_button!

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
  end
end