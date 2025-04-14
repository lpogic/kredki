require_relative '../text/text_line'
require_relative 'option_group'
require_relative '../theme'

module Kredki
  module UI
    class Option < Pad

      def << arg
        case arg
        when String
          string! arg
        else
          super
        end
      end

      class PickEvent < Kredki::UI::Event
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
          @pad.area.color = @pad.button_top? ? @color.darken : @pad.mouse_in? ? @color.lighten : @color
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

      param def group! group, custom = true
        @group&.remove self
        group&.append self
        @group = group
        @custom_group = custom
      end

      def on_pick! ...
        on!(PickEvent, ...)
      end

      def_flag :arrow

      defw_param :font_height, :font, :string

      #internal api

      def initialize
        super

        @theme = nil
      end

      def sketch p0
        super

        keyboardy!
        theme! :gray

        on_click! do
          report PickEvent.new
        end

        on_key! :space, :enter do |e|
          report PickEvent.new
          e.resolve
        end

        on_key! do |e|
          @group&.key e
        end

        on_mouse_enter! do |e|
          @group&.mouse_enter self
        end

        wh! :fit

        new_pad TextLine, mousy: false, keyboardy: false, y: 50r

        string! "Option"
      end

      def pw fit = false
        arrow_w = arrow? ? 16 : 0
        super + arrow_w
      end

      def pad
        @pads.first
      end
    end
  end
end
