require 'forwardable'
require_relative 'text/text_line'
require_relative 'theme'

module Kredki
  module UI
    class ButtonPad < Pad
      extend Forwardable

      class SimpleColorBasedTheme < Theme
        model :color

        def attach! pad
          super pad,
            pad.on_focus_gain!,
            pad.on_focus_lose!,
            pad.on_mouse_button_down!,
            pad.on_mouse_button_up!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!
        end

        def repaint
          @pad.area.color = @pad.button_top? ? @color.darken : @pad.mouse_in? ? @color.lighten : @color
          @pad.area.stroke_color = @pad.keyboard_in? ? :yellow : @color.darken
        end
      end

      def color_theme color
        SimpleColorBasedTheme.new color
      end

      param def theme! theme
        theme = theme.size > 1 ? theme : theme.first
        return if @theme == theme
        set_theme case theme
        when Theme
          theme
        when Symbol, Array, Color
          color_theme Kredki.color theme
        else raise_ia theme 
        end
        @theme = theme
      end

      attr :text

      #internal api

      def initialize
        super

        @theme = nil
        @text = new_pad TextLine, "Button", mousy: false, keyboardy: false
      end

      def sketch p0
        super

        keyboardy!
        stroke_width! 2
        theme! :gray
        layout! Center
        wh! :fit
      end

      def resize e
        if e.target != self
          e.resolve
          set_size or arrange
        end
      end

      def pad
        @pads.first
      end

      def update_margin
        super.tap{ set_size }
      end

      def push_pad ...
        super.tap{ set_size }
      end

      def remove_pad pad, transfer
        super.tap{ set_size }
      end

      def set_theme theme
        @_theme&.detach!
        theme.attach! self
        @_theme = theme
        true
      end
    end
  end
end