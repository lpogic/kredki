module Kredki
  module Pads
    # A control that allows you to set a value by dragging a handle in Y axis.
    class SliderY < Slider

      # :section: LEVEL 2

      def process_drag e, speed = 1
        hsy = @handle.area_size_y
        max_y = area_size_y - hsy
        @c0 = @handle.area_y if e.start?
        start_y = layer.pin_xy[1]
        y = [[0, @c0 + (e.y - start_y) * speed].max, max_y].min
        report EditEvent.new(1.0 * y / max_y, e) if max_y > 0
      end

      def sketch
        super

        set_size_x 10
      end

      def behavior
        super

        on_mouse_press :primary do |e|
          @handle.start_drag @handle.translate(0, @handle.area_size_x * 0.5), :primary
          e.close
        end
      end

      def arrange request_size_y = nil
        csy = clip_size_y
        request_size_y ||= 3 * csy
        size_y = (csy.to_f / request_size_y * csy).clamp 20, [csy - 20, 20].max
        @handle.update_size area_size_x, size_y
        @handle.update_xy 0, ((csy - size_y) * @value.to_f.then{|it| it.nan? ? 0 : it.clamp(0..1) }).ceil
      end
    end
  end
end