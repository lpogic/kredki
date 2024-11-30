require 'forwardable'
require_relative '../has_flags'

module Kredki
  module Context
    class Mouse
      extend Forwardable
      extend HasFlags

      model :context, :mouse do
        Mouse.init_flags self
      end

      def indexes input
        input.flatten.map{ @mouse.button(_1).to_i }.uniq
      end

      def on_move! ...
        @context.on_mouse_move!(...)
      end
      
      def on_scroll! ...
        @context.on_mouse_scroll!(...)
      end

      aliasing def on_down! ...
        @context.on_mouse_button!(...)
      end, :on_button!, :on_button_down!

      aliasing def on_up! ...
        @context.on_mouse_button_up!(...)
      end, :on_button_up!

      def on_drop! ...
        @context.on_drop!(...)
      end

      def on_enter! ...
        @context.on_enter!(...)
      end

      def on_leave! ...
        @context.on_leave!(...)
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
        @context.action.translate *@mouse.xy, @context
      end

      def_delegators :@mouse,
        :down?, :position, :in_window?,
        :relative!, :relative=, :relative

      #internal api

      def set_capture capture
        Abi.mouse_set_capture capture ? 1 : 0
      end

      def get_capture
        w = @context.window
        Abi.window_get_flags(w.pointer) & 0x4000 != 0 if w
      end

      def set_grab grab
        @context.window&.grab! grab
      end

      def get_grab
        @context.window&.grab?
      end
    end
  end
end