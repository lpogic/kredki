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
        model :@R_base_color, :R_selection_color, :@N_proc

        def to_proc
          color = @base_color
          selection_color = @selection_color
          @proc ||= proc do
            area.color = button_top? ? selection_color.dark : keyboard_in? ? selection_color : color
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

      aliasing def submenu_position! position
        @submenu_position = position
      end, :submenu_position=

      def submenu_position
        @submenu_position
      end

      def_flag :submenu_arrow, nil: true

      def submenu!
        p0 = self
        if !@submenu
          @submenu = orphan!.new_pad OptionsLayer do
            attach = proc do
              w = @options.pads.map(&:max_x).max
              @options[Option..]{ w! w }
              attach! p0.action, *p0.position_options(@options)
            end

            on! Option::PickEvent do |e|
              p0.report e
            end

            p0.on_pick! do |e|
              if e.target == p0
                attach.call
                e.resolve
              end
            end

            p0.on_focus_gain! do |e|
              attach.call
            end

            p0.on_key! :left, :right do |e|
              s[Option]&.focus! and e.resolve
            end
          end

          new_pad Pad, area: RightTriangle.new, wh: 10, x: pad.x + pad.w + 20, y: 5 if submenu_arrow?
        end
        @submenu
      end

      class RightTriangle < Kredki::Area

        def repaint
          stroke_width! 3
          move_to! 0, 0
          line_to! @w, @h / 2
          line_to! 0, @h
        end
      end
    
    
    

      def_pad :option!, true do
        submenu!.option! autosized: false
      end

      defw_resp :string!, :string=, :string
      defw_resp :fh!, :fh=, :font!, :font=

      def_flag :autosized, nil: true

      #internal api

      def initialize
        super

        @theme = nil
      end

      def sketch p0
        super

        keyboardy!
        new_pad TextLine, mousy: false, keyboardy: false
        theme! :gray, :green

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

        on_key! :space, :enter do |e|
          report PickEvent.new
          e.resolve
        end

        on_focus_gain! do
          repaint
        end

        on_focus_lose! do
          @submenu&.detach!
          repaint
        end

        string! "Option"
      end

      def position_options options
        case @submenu_position
        when :vertical
          x, y = *translate(0, h)
          if x + options.w > action.w
            x = [action.w - options.w, 0].max
          end
          if y + options.h > action.h
            y = [y - options.h, 0].max
          end
          [x, y]
        else
          x, y = *translate(w, 0)
          if x + options.w > action.w
            x = [x - w - options.w, 0].max
          end
          if y + options.h > action.h
            y = [action.h - options.h, 0].max
          end
          [x, y]
        end
      end

      def pad
        @pads.first
      end

      def repaint
        instance_exec &@theme
      end

      def resize e
        if e.target != self
          if autosized?
            w! max_x
            e.resolve
          end
          report RepaintEvent.new
        end
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

      def max_x
        @pads.map(&:max_x).max + pad.x
      end
    end
  end
end