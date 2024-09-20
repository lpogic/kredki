module Kredki
  module UI
    class Slide < Pad

      def value
        @value
      end

      def set_value v
        @value = v
      end

      def on_change! &block
        on_event! PadChangeEvent, &block
      end

      def on_edit! &block
        on_event! PadEditEvent, &block
      end

      def value! v
        v = v.to_f
        v = 1.0 if v > 1.0
        v = 0.0 if v < 0.0
        set_value v
        set_offset v
      end

      attr :handle
    end

    class YSlide < Slide

      def sketch p0
        super
        p0 = self

        @value = 0

        @handle = pad! h: 20, color: :gray do
        
          on_drag! do |e|
            y = [[0, e.y - h / 2].max, p0.h - h].min
            y! y
            p0.set_value 1.0 * y / (p0.h - h)
            p0.event PadEditEvent.new
          end
    
          on_drop! do
            p0.event PadChangeEvent.new
          end

          on_resize! do
            y! (p0.h - h) * p0.value
          end
        end

        on_resize! do
          @handle.y! (h - @handle.h) * value
        end
    
        on_mouse_button! do |e|
          @handle.drag!
        end
      end

      def set_offset o
        @handle.y = o * (h - @handle.h)
      end
    end

    class XSlide < Slide

      def sketch p0
        super

        @value = 0

        @handle = pad! w: 20, color: :gray do
        
          on_drag! do |e|
            x = [[0, e.x - w / 2].max, p0.w - w].min
            x! x
            p0.set_value 1.0 * x / (p0.w - w)
            p0.event PadEditEvent.new
          end
    
          on_drop! do
            p0.event PadChangeEvent.new
          end

          on_resize! do
            x! (p0.w - w) * p0.value
          end
        end

        on_resize! do
          @handle.x! (w - @handle.w) * value
        end
    
        on_mouse_button! do |e|
          @handle.drag!
        end
      end

      def set_offset o
        @handle.x = o * (w - @handle.w)
      end
    end
  end
end