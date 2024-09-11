require 'forwardable'
require_relative '../has_flags'

module Kredki
  class Action
    class Mouse
      extend Forwardable
      extend HasFlags

      model :action, :mouse do
        Mouse.init_flags self
      end

      def indexes *input
        input.flatten.map{ @mouse.button(_1).to_i }.uniq
      end

      def on_move! ...
        @action.on_mouse_move!(...)
      end
      
      def on_scroll! ...
        @action.on_mouse_scroll!(...)
      end

      def on_button! ...
        @action.on_mouse_button!(...)
      end

      alias_method :on_button_down!, :on_button!

      def on_button_up! ...
        @action.on_mouse_button_up!(...)
      end

      def on_drop! ...
        @action.on_drop!(...)
      end

      def on_enter! ...
        @action.on_enter!(...)
      end

      def on_leave! ...
        @action.on_leave!(...)
      end

      def_flag :capture, :set_capture, :get_capture
      def_flag :grab, :set_grab, :get_grab

      def x
        xy[0]
      end

      def y
        xy[1]
      end

      def xy
        offset = @action.parent.translate 0, 0
        [@mouse.x - offset[0], mouse.y - offset[1]]
      end

      def_delegators :@mouse,
        :down?, :position,
        :relative!, :relative=, :relative

      #internal api

      def set_capture capture
        Abi.mouse_set_capture capture ? 1 : 0
      end

      def get_capture
        w = @action.window
        Abi.window_get_flags(w.pointer) & 0x4000 != 0 if w
      end

      def set_grab grab
        @action.window&.grab! grab
      end

      def get_grab
        @action.window&.grab?
      end
    end
  end
end