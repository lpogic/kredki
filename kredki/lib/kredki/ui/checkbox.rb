require_relative 'theme'

module Kredki
  module UI
    class Checkbox < Pad
      extend Forwardable
      extend HasParams
      extend HasFlags

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
          @pad.area.color = @pad.pin_top? ? @color.darken : @pad.mouse_in? ? @color.lighten : @color
          @pad.area.stroke_color = @pad.keyboard_in? ? :stroke_focus : @color.darken
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

      flag :checked, set: :set_checked

      #internal api

      def initialize
        super

        @theme = nil
        @check = new Pad, mousy: false, keyboardy: false, color: 0, wh: 100r do
          stroke! color: :text, size: 3
          area! do |w, h|
            move_to! 2, h / 2
            line_to! w / 2, h - 1
            line_to! w - 2, 2
          end
          hide!
        end
      end

      def sketch p0
        super

        keyboardy!
        stroke_size! 1
        theme! :gray
        layout! :center
        wh! 20
        m! 3

        Event.group on_mouse_click!, on_key!(:space, :enter) do
          checked! :~
        end

      end

      def set_checked checked
        @checked = checked
        @check.show! checked
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