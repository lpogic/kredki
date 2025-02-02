require_relative '../text/text_line'
require_relative 'option_group'

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

      module Theme
      end

      class ColorBasedTheme
        include Theme
        model :@R_base_color, :@N_proc

        def to_proc
          color = @base_color
          @proc ||= proc do
            area.color = button_top? ? color.dark : keyboard_in? ? color.light : color
          end
        end
      end

      def color_theme color
        ColorBasedTheme.new color
      end

      aliasing def theme! theme
        theme = case theme
        when Proc, Theme
          theme
        when Symbol, Array
          color_theme Kredki.color theme
        else raise_ia theme 
        end
        @theme != theme && begin
          @theme = theme
          repaint
        end
      end, :theme=

      def theme
        @theme
      end

      aliasing def group! group, custom = true
        @group&.remove self
        group&.append self
        @group = group
        @custom_group = custom
      end, :group=

      def group
        @group
      end

      def on_pick! ...
        on!(PickEvent, ...)
      end

      def_flag :arrow, nil: true

      defw_resp :string!, :string=, :string
      defw_resp :fh!, :fh=, :font!, :font=

      #internal api

      def initialize
        super

        @theme = nil
      end

      def sketch p0
        super

        keyboardy!
        theme! :gray

        on_repaint! do |e|
          repaint
          e.resolve
        end

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

        on_focus_gain! do
          repaint
        end

        on_focus_lose! do
          repaint
        end

        w! proc{ pw }
        h! proc{ ph }

        new_pad TextLine, mousy: false, keyboardy: false, y: 50r

        string! "Option"
      end

      def pw
        arrow_w = arrow? ? 16 : 0
        @me + @mw + (@pads.first&.pw || 0) + arrow_w
      end

      def resize e
        if e.target != self
          e.resolve
          update_size
        end
      end

      def pad
        @pads.first
      end

      def update_margin
        super.tap{ update_size }
      end

      def push_pad ...
        super.tap{ update_size }
      end

      def remove_pad pad, transfer
        super.tap{ update_size }
      end

      def repaint
        instance_exec &@theme
      end

      def mouse_button_down e
        super
        report RepaintEvent.new
      end

      def mouse_button_up e
        super
        report RepaintEvent.new
      end

      def mouse_enter e
        super
        report RepaintEvent.new
      end

      def mouse_leave e
        super
        report RepaintEvent.new
      end
    end
  end
end
