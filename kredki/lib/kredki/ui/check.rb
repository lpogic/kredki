require_relative 'theme'

module Kredki
  module UI
    class Check < ShapePad
      extend Forwardable
      extend HasParams

      class ColorTheme < Theme
        model :color

        def attach! pad
          super pad, [
            pad.on_focus_enter!,
            pad.on_focus_leave!,
            pad.on_mouse_down!,
            pad.on_mouse_up!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!,
          ]
        end

        def repaint
          @pad.area.fill_color = @pad.pin_top? ? @color.darken : @pad.mouse_in? ? @color.lighten : @color
          @pad.area.stroke_color = @pad.keyboard_in? ? :stroke_focus : @color.darken
        end
      end

      def color_theme color
        ColorTheme.new color
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


      flag def checked! s = true
        c, n = show? s
        return if c == n
        checked n
        @checked = n
        true
      end

      #internal api

      def initialize
        super

        @theme = nil
        @check = new ShapePad, mousy: false, keyboardy: false, color: 0, wh: 1r do
          stroke! color: :text, size: 3
          area! do |w, h|
            xy! 2, h * 0.5
            line! w * 0.5, h - 1
            line! w - 2, 2
          end
          hide!
        end
      end

      def sketch p0
        super

        keyboardy!
        stroke_size! 1
        theme! :gray
        layout! Center
        wh! 20
        m! 3

        Event.group on_mouse_click!, on_key!(:space, :enter) do
          checked! :~
        end

      end

      def set_checked checked
        @check.show! checked
      end

      def set_theme theme
        @theme_object&.detach!
        theme.attach! self
        @theme_object = theme
        true
      end
    end
  end
end