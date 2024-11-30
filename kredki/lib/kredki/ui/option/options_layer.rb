module Kredki
  module UI
    class OptionsLayer < Layer

      def attach! target, x = nil, y = nil
        x, y = *target.translate(x || target.w / 2, y || target.h / 2)

        s[Options] do
          xy! x, y
          focus!
        end
        super target.action
      end

      def_forward GridPad, :option!
      def_flag :autodetach!, true, true

      #internal api

      def initialize
        super

        OptionsLayer.init_flags self
      end

      def sketch p0
        super

        new_pad Options

        on_key! :escape, &proc.detach_request
        on! Option::PickEvent, &proc.detach_request
      end

      def mouse_button_down e
        detach_request e
      end

      def mouse_button_up e
      end

      def detach_request e
        if autodetach?
          detach!
          e.resolve
        end
      end


    end
  end
end