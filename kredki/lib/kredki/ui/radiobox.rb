require 'forwardable'
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

      def self.group param, target
        case param
        when RadioGroup
          param
        when false, nil
          target.grand RadioGroup
        else
          (@groups ||= {})[param] ||= RadioGroup.new
        end
      end

      param def group! group
        return if @group == group
        @group = group
        update_group
        true
      end, get: def group
        @group || @_group
      end

      def_flag :checked, set: :update_checked

      #internal api

      def initialize
        super

        @theme = nil
        @check = new Pad, mousy: false, keyboardy: false, color: :text, wh: 100r do
          area! do |w, h|
            ellipse! w / 2, h / 2, w / 2
          end
          hide!
        end
        @group = false
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
          @_group&.key e, self
        end

      end

      def update_checked checked
        @_group&.set_checked self, checked or set_checked checked
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

      def update_group
        group = self.class.group(@group, self)
        return if @_group == group
        @_group&.remove self
        group&.append self
        @_group = group
        true
      end

      def c_set_parent
        super
        update_group unless @group
      end
    end
  end
end