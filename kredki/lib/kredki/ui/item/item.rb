require_relative '../text_pad'
require_relative '../theme'

module Kredki
  module UI
    class Item < Pad
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
        model :value, :origin

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

      # param_service def text
      #   @text
      # end

      def has_subitem?
        false
      end

      def down? keyboard_in = nil
        keyboard_in = keyboard_in? if keyboard_in.nil?
        pin_top? :primary or (
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
        @text = new TextPad, "", mousy: false
      end

      def sketch p0
        super

        keyboardy!
        theme! :gray
        layout! :x_begin_center
        h! 24
        w! :fit

        on_mouse_click! :primary do |e|
          report PickEvent.new(content, e)
        end

        on_key! :space, :enter do |e|
          report PickEvent.new(content, e)
          e.resolve
        end
      end

      def mouse_enter e
        parent&.mouse_enter self if action.event.is_a? Kredki::MouseEvent
      end

      def min_w
        @text.fit_w
      end
    end
  end
end
