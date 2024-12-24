require_relative 'options'

module Kredki
  module UI
    class ScrollOptionsLayer < Layer

      def attach! action, x, y, w
        @scroll.alter do
          xy! x, y
          w! w
          s[Option..] = {w: w}
        end.attach! self
        super action
        @scroll[Option]&.focus!
      end

      def_forward Options, :option!
      def_flag :autodetach, nil: true

      #internal api

      def initialize
        super
      end

      def sketch p0
        super

        @scroll = new_pad ScrollPad do
          new_pad Options
        end

        on_key! :escape, &proc.detach_request
        on! Option::PickEvent, &proc.detach_request
      end

      def mouse_button_down e
        detach_request e
      end

      def mouse_button_up e
      end

      def detach_request e
        detach! if autodetach?
      end
    end
  end
end