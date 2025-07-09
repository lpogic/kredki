require 'forwardable'
require_relative 'text_pad'
require_relative 'theme'

module Kredki
  module UI
    class ButtonPad < Pad
      extend Forwardable

      class ColorTheme < Theme
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
          @pad.area.stroke_color = @pad.keyboard_in? && !@pad.button_top? ? :stroke_focus : @color.darken
        end
      end

      def color_theme color
        ColorTheme.new color
      end

      param def theme! *theme
        theme = theme.reduce_dim
        return if @theme == theme
        set_theme case theme
        when Theme
          theme
        when Symbol, Array, Color
          color_theme Kredki.color theme
        else raise_ia theme 
        end
        @theme = theme
        true
      end

      param def color! *color
        theme! *color
      end, get: def theme
        @_theme.color
      end

      def text
        self[Text]
      end

      def << arg
        case arg
        when String
          text << arg
        else
          super
        end
      end

      #internal api

      def initialize
        super

        @theme = nil
      end

      def sketch p0
        super

        new TextPad, "Button"

        keyboardy!
        stroke_width! 1
        theme! :gray
        layout! :xc
        wh! :fit
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