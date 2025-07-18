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
            pad.on_mouse_down!,
            pad.on_mouse_up!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!,
            pad.on_key_down!,
            pad.on_key_up!
        end

        def repaint
          kb_in = @pad.keyboard_in?
          @pad.area.color = @pad.down?(kb_in) ? @color.darken : @pad.mouse_in? ? @color.lighten : @color
          @pad.area.stroke_color = kb_in && !@pad.button_top?(:primary) ? :stroke_focus : @color.darken
        end
      end

      class ButtonClickEvent < Event
        model :origin, :<
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
      end, get: def color
        @_theme.color
      end

      def text
        self[TextPad]
      end

      def << arg
        case arg
        when String
          text << arg
        else
          super
        end
      end

      def on_click!(...)
        on!(ButtonClickEvent, ...)
      end

      def down? keyboard_in = nil
        keyboard_in = keyboard_in? if keyboard_in.nil?
        button_top? :primary or (
          keyboard_in and (
            key_down? :space or
            key_down? :enter
          )
        )
      end

      #internal api

      def initialize
        super

        @theme = nil
      end

      def sketch p0
        super

        new TextPad, "Button" do
          mousy! false
        end

        keyboardy!
        stroke_width! 1
        theme! :gray
        layout! :xc
        wh! :fit
        m! 3

        on_mouse_click! :primary do |e|
          report ButtonClickEvent.new e
          e.resolve
        end

        on_key! :space, :enter do |e|
          report ButtonClickEvent.new e
          e.resolve
        end
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