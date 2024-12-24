require 'forwardable'
require_relative 'text/text_line'

module Kredki
  module UI
    class ButtonPad < Pad
      extend Forwardable

      def << arg
        case arg
        when String
          string! arg
        else
          super
        end
      end

      module Theme
      end

      class ColorBasedTheme
        include Theme
        model :@R_base_color, :@N_proc

        def to_proc
          color = @base_color
          @proc ||= proc do
            area.color = button_top? ? color.dark : mouse_in? ? color.light : color
            area.stroke_color = keyboard_top? ? Kredki.color(:yellow) : color
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

      defw_resp :string!, :string=, :string

      #internal api

      def initialize
        super

        @theme = nil
      end

      def sketch p0
        super

        keyboardy!
        stroke_width! 1
        theme! :gray

        on_repaint! do |e|
          repaint
          e.resolve
        end

        on_focus_gain! do |e|
          report RepaintEvent.new
          e.resolve
        end

        on_focus_lose! do |e|
          report RepaintEvent.new
          e.resolve
        end

        w! proc{ @me + @mw + (pad&.then{ _1.w } || 0) }
        h! proc{ @mn + @ms + (pad&.then{ _1.h } || 0) }

        new_pad TextLine, mousy: false, keyboardy: false, xy: 50r

        string! "Button"
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