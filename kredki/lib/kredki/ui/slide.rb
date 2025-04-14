require_relative 'theme'

module Kredki
  module UI
    class Slide < Pad

      param def value! v
        f = v.to_f 
        v = f.nan? ? 0 : f.clamp(0..1)
        @value != v && begin
          set_value v
          set_offset v
          report EditEvent.new
          report ChangeEvent.new
          true
        end
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
            pad.on_mouse_button_down!,
            pad.on_mouse_button_up!,
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

      def sketch2 p0
        theme! :gray

        @handle.alter do
          on_drop! do |e|
            p0.report ChangeEvent.new
            e.resolve
          end

          on_mouse_button! do |e|
            drag! e.xy
            e.resolve
          end
        end
      end

      def set_value v
        @value = v
      end

      attr :handle
    end

    class HorizontalSlide < Slide

      def sketch p0
        super

        h! 10

        @handle = new_pad.alter w: 20, h: 100r, color: :gray do
        
          on_drag! do |e|
            start_x = @button_down_xy[0]
            x = [[0, self.sx + e.x - start_x].max, p0.sw - w].min
            x! x
            p0.set_value 1.0 * x / (p0.sw - w)
            p0.report EditEvent.new
            e.resolve
          end
    
          on_resize! do |e|
            x! (p0.sw - w) * p0.value
            e.resolve
          end
        end

        on_resize! do
          @handle.x! (w - @handle.sw) * value
        end
    
        on_mouse_button! do |e|
          @handle.drag! [@handle.sw / 2, 0]
          e.resolve
          e.break
        end

        sketch2 p0
      end

      def set_offset o
        @handle.x = o * (w - @handle.sw)
      end
    end

    class VerticalSlide < Slide

      def sketch p0
        super

        w! 10

        @handle = pad! h: 20, w: 100r, color: :gray do
        
          on_drag! do |e|
            start_y = @button_down_xy[1]
            y = [[0, self.y + e.y - start_y].max, p0.sh - h].min
            y! y
            p0.set_value 1.0 * y / (p0.sh - h)
            p0.report EditEvent.new
            e.resolve
          end

          on_resize! do |e|
            y! (p0.sh - h) * p0.value
            e.resolve
          end
        end

        on_resize! do
          @handle.y! (h - @handle.sh) * value
        end

        on_mouse_button! do |e|
          @handle.drag! [0, @handle.sh / 2]
          e.resolve
          e.break
        end

        
        sketch2 p0
      end

      def set_offset o
        @handle.y = o * (h - @handle.sh)
      end
    end
  end
end