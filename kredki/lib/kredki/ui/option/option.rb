require_relative '../text_pad'
require_relative '../theme'

module Kredki
  module UI
    class Option < Pad
      extend HasEventResolvers

      def << arg
        case arg
        when String
          content! arg
        else
          super
        end
      end

      class PickEvent < Kredki::UI::Event
        model :value

        def ~()
          @value
        end
      end

      class SimpleColorBasedTheme < Theme
        model :color

        def attach! pad
          super pad,
            pad.on_focus_enter!,
            pad.on_focus_leave!,
            pad.on_mouse_down!,
            pad.on_mouse_up!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!
        end

        def repaint
          @pad.area.fill_color = @pad.pin_in? ? @color.darken : @pad.keyboard_in? ? @color.lighten : @color
        end
      end

      def color_theme color
        SimpleColorBasedTheme.new color
      end

      param def theme! theme
        theme = case theme
        when Theme
          theme
        when Symbol, Array
          color_theme Kredki.color theme
        else raise_ia theme 
        end
        @theme != theme && begin
          @theme = theme
          theme.attach! self
        end
      end

      event_resolver :on_pick!, PickEvent

      param_delegate :@text,
        :content

      param_service def text
        @text
      end

      def has_suboption?
        false
      end

      #internal api

      def initialize
        super

        @theme = nil
        @text = new TextPad, "Option", mousy: false
      end

      def sketch p0
        super

        keyboardy!
        theme! :gray
        layout! :wc
        h! 24
        w! :fit

        on_mouse_click! do
          report PickEvent.new content
        end

        on_key_down! :space, :enter do |e|
          report PickEvent.new content
          e.resolve
        end
      end

      def mouse_enter e
        parent&.mouse_enter self
      end

      def min_w
        @text.fit_w
      end
    end
  end
end
