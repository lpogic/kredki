require 'forwardable'
require_relative 'text/text_line'
require_relative 'theme'

module Kredki
  module UI
    class ButtonPad < Pad
      extend Forwardable

      def << arg
        case arg
        when String
          string! arg
        else
          super
        end
      end

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
          @pad.area.color = @pad.button_top? ? @color.dark : @pad.mouse_in? ? @color.light : @color
        end
      end

      def color_theme color
        SimpleColorBasedTheme.new color
      end

      vparam def theme! theme
        theme = case theme
        when Theme
          theme
        when Symbol, Array, Color
          color_theme Kredki.color theme
        else raise_ia theme 
        end
        @theme != theme and set_theme theme
      end

      param def color! *color
        case color
        in [false]
          area.hide!
        else
          area.show!
          theme! *color
        end
      end, get: false

      attr :text

      #internal api

      def initialize
        super

        @theme = nil
      end

      def sketch p0
        super

        keyboardy!
        stroke_width! 1
        theme! :gray
        layout! Aim

        w! proc{ @me + @mw + (pad&.then{ _1.w } || 0) }
        h! proc{ @mn + @ms + (pad&.then{ _1.h } || 0) }

        @text = new_pad TextLine, "Button", mousy: false, keyboardy: false
      end

      def resize e
        if e.target != self
          e.resolve
          update_size
        end
      end

      def pad
        @pads.first
      end

      def update_margin
        super.tap{ update_size }
      end

      def push_pad ...
        super.tap{ update_size }
      end

      def remove_pad pad, transfer
        super.tap{ update_size }
      end

      def set_theme theme
        @theme&.detach!
        theme.attach! self
        @theme = theme
        true
      end
    end
  end
end