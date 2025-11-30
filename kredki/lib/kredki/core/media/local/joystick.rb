module Kredki
  module LocalMedia
    class Joystick
      extend Forwardable
      extend HasEventResolvers

      model :host, :joystick

      def buttons input
        input.flatten.map{ @joystick.button(_1).to_i }.uniq
      end

      def axes input
        input.flatten.map{ @joystick.axis(_1).to_i }.uniq
      end

      event_resolver def on_down! ...
        @host.on_joystick_down!(self, ...)
      end

      event_resolver def on_up! ...
        @host.on_joystick_up!(self, ...)
      end

      event_resolver def on_axis! ...
        @host.on_joystick_axis!(self, ...)
      end

      def_delegators :@joystick,
        :down?,
        :value
    end
  end
end