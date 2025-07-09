require_relative '../text_pad'
require_relative 'option_group'
require_relative 'option_dropdown_layer'
require_relative '../theme'

module Kredki
  module UI
    class Option < Pad

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
            pad.on_focus_gain!,
            pad.on_focus_lose!,
            pad.on_mouse_button_down!,
            pad.on_mouse_button_up!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!
        end

        def repaint
          @pad.area.color = @pad.button_in? ? @color.darken : @pad.keyboard_in? ? @color.lighten : @color
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

      def self.group param, target
        case param
        when OptionGroup
          param
        when false, nil
          target.grand OptionGroup
        else
          (@groups ||= {})[param] ||= OptionGroup.new
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

      def on_pick! ...
        on!(PickEvent, ...)
      end

      def_flag :arrow


      def content! content
        @text.content! content
      end

      def content
        @text.content
      end

      param_service def text
        @text
      end

      def option! ...
        dropdown!.option!(...)
      end

      param def dropdown! ...
        @dropdown ||= new OptionDropdownLayer
        @dropdown.alter(...)
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
        layout! :start, :center
        wh! :fit

        on_click! do
          report PickEvent.new content
        end

        on_key! :space, :enter do |e|
          report PickEvent.new content
          e.resolve
        end

        on_key! :right do |e|
          if dr = dropdown
            dr.load! self unless dr.loaded?
            dr[Option]&.focus! and e.resolve
          end
          e.resolve
        end

        on_key! do |e|
          @_group&.key e
        end

        on_mouse_enter! do |e|
          @_group&.mouse_enter self
          if dr = dropdown
            dr.update_keyboard_pad nil if dr.loaded?
          end
          e.resolve
        end
      end

      def pw fit = false
        arrow_w = @dropdown ? 16 : 0
        super + arrow_w
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
