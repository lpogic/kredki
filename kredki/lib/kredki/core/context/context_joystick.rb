require 'forwardable'

module Kredki
  module Context
    class Joystick
      extend Forwardable

      model :context, :joystick

      def buttons input
        input.flatten.map{ @joystick.button(_1).to_i }.uniq
      end

      def axes input
        input.flatten.map{ @joystick.axis(_1).to_i }.uniq
      end

      def on_down! ...
        @context.on_joystick_down!(self, ...)
      end

      def on_up! ...
        @context.on_joystick_up!(self, ...)
      end

      def on_axis! ...
        @context.on_joystick_axis!(self, ...)
      end

      def_delegators :@joystick,
        :down?,
        :value

    end
  end
end