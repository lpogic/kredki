require_relative '../text/text_line'

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
        model :base_color_avr!, :proc_a!

        def to_proc
          color = @base_color
          @proc ||= proc do
            area.color = button_top? ? color.dark : keyboard_in? ? :green : color
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

      def on_pick! ...
        on!(PickEvent, ...)
      end

      #internal api

      def initialize
        super

        @theme = nil
        Option.init_flags self
      end

      def_flag :selected

      def sketch p0
        super

        keyboardy!
        new_pad TextLine, mousy: false, keyboardy: false
        theme! :gray

        on_repaint! do |e|
          repaint
          e.resolve
        end

        on_enter! do
          gain_keyboard
        end

        on_click! do
          report PickEvent.new
        end

        on_key! :space do
          report PickEvent.new
          e.resolve
        end

        on_focus_gain! do
          repaint
        end

        on_focus_lose! do
          repaint
        end

        string! "Option"
      end

      defw_resp :string!, :string=, :string
      defw_resp :fh!, :fh=, :font!, :font=

      def pad
        @pads.first
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