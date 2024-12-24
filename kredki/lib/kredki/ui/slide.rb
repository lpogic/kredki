module Kredki
  module UI
    class Slide < Pad

      def on_change! &block
        on! ChangeEvent, &block
      end

      def on_edit! &block
        on! EditEvent, &block
      end

      aliasing def value! v
        v = v.to_f.clamp 0.0..1.0
        @value != v && begin
          set_value v
          set_offset v
          report EditEvent.new
          report ChangeEvent.new
          true
        end
      end, :value=

      def value
        @value
      end

      module Theme
      end

      class ColorBasedTheme
        include Theme
        model :@R_base_color, :@N_proc

        def to_proc
          color = @base_color
          @proc ||= proc do
            @handle.color = mouse_in? ? color.light : color.dark
          end
        end
      end

      aliasing def theme! theme
        theme = case theme
        when Proc, Theme
          theme
        when Symbol, Array
          ColorBasedTheme.new Kredki.color theme
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

      #internal api

      def initialize
        super

        @value = 0.0
      end

      def sketch p0
        super

        on_repaint! do |e|
          repaint
          e.resolve
        end
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

      def repaint
        instance_exec &@theme
      end

      def mouse_button_down e
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

      def mouse_button_up e
        super
        report RepaintEvent.new
      end
    end

    class HorizontalSlide < Slide

      def sketch p0
        super

        h! 10

        @handle = new_pad.alter w: 20, color: :gray do
        
          on_drag! do |e|
            start_x = @button_down_xy[0]
            x = [[0, self.x + e.x - start_x].max, p0.w - w].min
            x! x
            p0.set_value 1.0 * x / (p0.w - w)
            p0.report EditEvent.new
            e.resolve
          end
    
          on_resize! do |e|
            x! (p0.w - w) * p0.value
            e.resolve
          end
        end

        on_resize! do
          @handle.x! (w - @handle.w) * value
        end
    
        on_mouse_button! do |e|
          @handle.drag! [@handle.w / 2, 0]
          e.resolve
          e.break
        end

        sketch2 p0
      end

      def set_offset o
        @handle.x = o * (w - @handle.w)
      end
    end

    class VerticalSlide < Slide

      def sketch p0
        super

        w! 10

        @handle = pad! h: 20, color: :gray do
        
          on_drag! do |e|
            start_y = @button_down_xy[1]
            y = [[0, self.y + e.y - start_y].max, p0.h - h].min
            y! y
            p0.set_value 1.0 * y / (p0.h - h)
            p0.report EditEvent.new
            e.resolve
          end

          on_resize! do |e|
            y! (p0.h - h) * p0.value
            e.resolve
          end
        end

        on_resize! do
          @handle.y! (h - @handle.h) * value
        end

        on_mouse_button! do |e|
          @handle.drag! [0, @handle.h / 2]
          e.resolve
          e.break
        end

        
        sketch2 p0
      end

      def set_offset o
        @handle.y = o * (h - @handle.h)
      end
    end
  end
end