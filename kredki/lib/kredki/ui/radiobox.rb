require 'forwardable'
require_relative 'theme'

module Kredki
  module UI
    class Radiobox < Pad
      extend Forwardable

      class SimpleColorBasedTheme < Theme
        model :color

        def attach! pad
          super pad,
            pad.on_focus_gain!,
            pad.on_focus_lose!,
            pad.on_mouse_down!,
            pad.on_mouse_up!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!
        end

        def repaint
          @pad.area.color = @pad.button_top? ? @color.darken : @pad.mouse_in? ? @color.lighten : @color
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

      def_flag :checked, set: :update_checked

      #internal api

      def initialize
        super

        @theme = nil
        @check = new Pad, mousy: false, keyboardy: false, color: :text, wh: 100r do
          area! do |w, h|
            ellipse! (w + 0) / 2, h / 2, w / 2
          end
          hide!
        end
      end

      def sketch p0
        super

        area! do |w, h|
          ellipse! w / 2, h / 2, w / 2 - 1
        end
        keyboardy!
        stroke_width! 1
        layout! :center
        wh! 16
        m! 4
        theme! :gray

        Event.group on_mouse_click!, on_key!(:space, :enter) do
          checked!
        end

        on_key_down! do |e|
          parent.key e, self
        end

      end

      def update_checked checked
        parent&.set_checked self, checked or set_checked checked
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