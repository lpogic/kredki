module Kredki
  module LocalMedia
    class Mouse
      extend Forwardable
      extend HasFlags
      extend HasParams

      model :reference, :mouse

      def indexes input
        input.flatten.map{ @mouse.button(_1).to_i }.uniq
      end

      def on_move! ...
        @reference.on_mouse_move!(...)
      end
      
      def on_scroll! ...
        @reference.on_mouse_scroll!(...)
      end

      def on_down! ...
        @reference.on_mouse_down!(...)
      end

      def on_up! ...
        @reference.on_mouse_up!(...)
      end

      def on_drop! ...
        @reference.on_drop!(...)
      end

      def on_enter! ...
        @reference.on_enter!(...)
      end

      def on_leave! ...
        @reference.on_leave!(...)
      end

      flag :capture, set: :set_capture, get: :get_capture
      flag :grab, set: :set_grab, get: :get_grab

      def x
        xy[0]
      end

      def y
        xy[1]
      end

      def xy
        @reference.action.screen_translate *@mouse.xy, @reference
      end

      def_delegators :@mouse,
        :down?, :in_window?

      param_delegate :@mouse, :relative

      #internal api

      def set_capture capture
        Abi.mouse_set_capture capture ? 1 : 0
      end

      def get_capture
        w = @reference.window
        Abi.window_get_flags(w.pointer) & 0x4000 != 0 if w
      end

      def set_grab grab
        @reference.window&.grab! grab
      end

      def get_grab
        @reference.window&.grab?
      end
    end
  end
end