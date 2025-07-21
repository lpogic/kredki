module Kredki
  module LocalMedia
    class Joystick
      extend Forwardable

      model :resource, :joystick

      def buttons input
        input.flatten.map{ @joystick.button(_1).to_i }.uniq
      end

      def axes input
        input.flatten.map{ @joystick.axis(_1).to_i }.uniq
      end

      def on_down! ...
        @resource.on_joystick_down!(self, ...)
      end

      def on_up! ...
        @resource.on_joystick_up!(self, ...)
      end

      def on_axis! ...
        @resource.on_joystick_axis!(self, ...)
      end

      def_delegators :@joystick,
        :down?,
        :value
    end
  end
end