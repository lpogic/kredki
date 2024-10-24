module Kredki
  module UI
    class Slide < Pad

      def sketch p0
        super

        @value = 0.0
      end

      def value
        @value
      end

      def set_value v
        @value = v
      end

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

      attr :handle
    end

    class XSlide < Slide

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
    
          on_drop! do |e|
            p0.report ChangeEvent.new
            e.resolve
          end

          on_resize! do |e|
            x! (p0.w - w) * p0.value
            e.resolve
          end

          on_mouse_button! do |e|
            drag! e.xy
            e.resolve
          end
        end

        on_resize! do
          @handle.x! (w - @handle.w) * value
        end
    
        on_mouse_button! do |e|
          @handle.drag! [@handle.w / 2, 0]
          e.resolve
        end
      end

      def set_offset o
        @handle.x = o * (w - @handle.w)
      end
    end

    class YSlide < Slide

      def sketch p0
        super

        w! 10

        @handle = pad! h: 20, color: :gray do
        
          on_drag! do |e|
            y = [[0, self.y + e.y - h / 2].max, p0.h - h].min
            y! y
            p0.set_value 1.0 * y / (p0.h - h)
            p0.report EditEvent.new
            e.resolve
          end
    
          on_drop! do |e|
            p0.report ChangeEvent.new
            e.resolve
          end

          on_resize! do |e|
            y! (p0.h - h) * p0.value
            e.resolve
          end

          on_mouse_button! do |e|
            drag! e.xy
            e.resolve
          end
        end

        on_resize! do
          @handle.y! (h - @handle.h) * value
        end

        on_mouse_button! do |e|
          @handle.drag! [0, @handle.h / 2]
          e.resolve
        end
      end

      def set_offset o
        @handle.y = o * (h - @handle.h)
      end
    end
  end
end