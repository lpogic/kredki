require_relative 'theme'

module Kredki
  module UI
    class Slide < Pad

      param def value! v, report_change = true
        f = v.to_f 
        value = f.nan? ? 0 : f.clamp(0..1)
        return if @value == value
        @value = value
        layer&.break_layout
        report EditEvent.new
        report ChangeEvent.new if report_change
        true
      end

      def on_change! &block
        on! ChangeEvent, &block
      end

      def on_edit! &block
        on! EditEvent, &block
      end

      class SimpleColorBasedTheme < Theme
        model :color

        def attach! pad
          super pad,
            pad.on_mouse_down!,
            pad.on_mouse_up!,
            pad.on_mouse_enter!,
            pad.on_mouse_leave!
        end

        def repaint
          @pad.handle.area.color = @pad.mouse_in? ? @color.lighten : @color.darken
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

      #internal api

      def initialize
        super

        @value = 0.0
      end

      def sketch p0
        super

        on_scroll! do |e|
          jump = Kredki.mouse.scrollbar_speed keyboard.alt?
          self.value -= jump * e.xory
          e.resolve
        end
      end

      def sketch2 p0
        theme! :gray

        @handle.alter do
          on_mouse_up! do |e|
            p0.report ChangeEvent.new
          end

          on_mouse_down! do |e|
            drag! e.xy, e.button
            e.resolve
          end
        end
      end

      attr :handle
    end

    class HorizontalSlide < Slide

      def sketch p0
        super

        h! 10

        @handle = new Pad, color: :gray do
          on_mouse_move! do |e|
            if e.drag
              start_x = layer&.mouse_down_xy[0]
              max_x = p0.sw - sw
              x = [[0, e.x - start_x].max, max_x].min
              p0.value! 1.0 * x / max_x, false
              e.resolve
            end
          end
        end
    
        on_mouse_down! :primary do |e|
          @handle.drag! @handle.translate(@handle.sw / 2, 0), :primary
          e.resolve
          e.break
        end

        sketch2 p0
      end

      def arrange lw = nil
        w = cw
        lw ||= 2 * w
        hw = (w.to_f / lw * w).clamp 20, [w - 20, 20].max
        @handle.set_size hw, 10
        @handle.set_xy (w - hw) * @value, 0
      end
    end

    class VerticalSlide < Slide

      def sketch p0
        super

        w! 10

        @handle = new Pad, color: :gray do
        
          drag_y = 0
          on_mouse_move! do |e|
            if e.drag
              drag_y = sy if e.drag == :start
              start_y = layer&.mouse_down_xy[1]
              max_y = p0.sh - sh
              y = [[0, drag_y + e.y - start_y].max, max_y].min
              p0.value! 1.0 * y / max_y, false
              e.resolve
            end
          end

        end

        on_mouse_down! :primary do |e|
          @handle.drag! @handle.translate(0, @handle.sh / 2), :primary
          e.resolve
          e.break
        end

        sketch2 p0
      end

      def arrange lh = nil
        h = ch
        lh ||= 2 * h
        hh = (h.to_f / lh * h).clamp 20, [h - 20, 20].max
        @handle.set_size 10, hh
        @handle.set_xy 0, (h - hh) * @value
      end
    end
  end
end