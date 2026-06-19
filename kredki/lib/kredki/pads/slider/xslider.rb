module Kredki
  module Pads
    # A control that allows you to set a value by dragging a handle in X axis.
    class Xslider < Slider

      # :section: LEVEL 2

      def process_drag e, speed = 1
        hsx = @handle.area_size_x
        max_x = area_size_x - hsx
        @c0 = @handle.area_x if e.start?
        start_x = layer.pin_xy[0]
        x = [[0, @c0 + (e.x - start_x) * speed].max, max_x].min
        report EditEvent.new(1.0 * x / max_x, e) if max_x > 0
      end

      def sketch
        super

        set_size_y 10
      end

      def behavior
        super

        on_mouse_press :primary do |e|
          @handle.start_drag @handle.translate(@handle.area_size_x * 0.5, 0), :primary
          e.close
        end
      end

      def arrange request_size_x = nil
        csx = clip_size_x
        request_size_x ||= 3 * csx
        size_x = (csx.to_f / request_size_x * csx).clamp 20, [csx - 20, 20].max
        @handle.update_size size_x, area_size_y
        @handle.update_xy ((csx - size_x) * @value.to_f.then{|it| it.nan? ? 0 : it.clamp(0..1) }).ceil, 0
      end
    end
  end
end