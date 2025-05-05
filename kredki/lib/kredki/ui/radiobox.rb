require 'forwardable'
require_relative 'text/text_line'
require_relative 'radio_group'
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
            pad.on_mouse_button_down!,
            pad.on_mouse_button_up!,
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

      def self.group param
        case param
        when RadioGroup
          param
        else
          (@groups ||= {})[param] ||= RadioGroup.new
        end
      end

      param def group! group
        return if @group == group
        @group = group
        s_group = self.class.group group
        return if @s_group == s_group
        @s_group&.remove self
        s_group&.append self
        @s_group = s_group
        true
      end

      def_flag :checked, set: :update_checked

      #internal api

      def initialize
        super

        @theme = nil
        @check = new_pad Pad, mousy: false, keyboardy: false, color: :text, wh: 100r do
          area! do |w, h|
            ellipse! w / 2, h / 2, w / 2
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
        m! 5
        theme! :gray

        Event.group on_click!, on_key!(:space, :enter) do
          checked!
        end

        on_key! do |e|
          @s_group&.key e, self
        end

      end

      def update_checked checked
        @s_group&.set_checked self, checked or set_checked checked
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