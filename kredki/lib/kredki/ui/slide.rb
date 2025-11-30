module Kredki
  module UI
    class Slide < ShapePad
      extend HasEventResolvers

      feature def value! v, report_change = true
        f = v.to_f 
        value = f.nan? ? 0 : f.clamp(0..1)
        return if @value == value
        @value = value
        layer&.break_layout
        report EditEvent.new
        report ChangeEvent.new if report_change
        true
      end

      feature def fill! *fill
        return fill! *Util.cover(yield(self.fill)) if block_given?
        fill = Util.uncover fill
        return if @fill == fill
        @fill = fill
        repaint
        true
      end

      event_resolver :on_change!, ChangeEvent
      event_resolver :on_edit!, EditEvent

      # :section: LEVEL 2

      def initialize
        super

        @value = 0.0
      end

      attr :handle

      def sketch
        super

        fill! :gray
      end

      def sketch_presence
        super

        Event.each(
          on_mouse_down!, 
          on_mouse_up!, 
          on_mouse_enter!, 
          on_mouse_leave!,
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @fill
        handle.area.fill = mouse_in? ? color.lighten : color.darken
      end

      def sketch_behavior
        super 

        on_mouse_scroll! do |e|
          jump = keyboard.alt? ? Kredki.mouse.scrollbar_alt_speed : Kredki.mouse.scrollbar_speed
          self.value -= jump * e.xory
          e.resolve
        end

        p0 = self

        @handle.alter do
          on_mouse_up! do |e|
            p0.report ChangeEvent.new
          end

          on_mouse_down! do |e|
            drag! e.xy, e.button.id
            e.resolve
          end
        end
      end
    end

    class HorizontalSlide < Slide

      def initialize
        super

        p0 = self
        @handle = new ShapePad, fill: :gray do
          x0 = 0
          on_mouse_move! do |e|
            if e.drag
              s = sw
              max_x = p0.sw - s
              x0 = sx if e.drag == :start
              start_x = layer.pin_xy[0]
              x = [[0, x0 + e.x - start_x].max, max_x].min
              p0.value! 1.0 * x / max_x, false
              e.resolve
            end
          end
        end
      end

      def sketch
        super

        h! 10
      end

      def sketch_behavior
        super

        on_mouse_down! :primary do |e|
          @handle.drag! @handle.translate(@handle.sw * 0.5, 0), :primary
          e.resolve
          e.break
        end
      end

      def arrange lw = nil
        w = clw
        lw ||= 3 * w
        hw = (w.to_f / lw * w).clamp 20, [w - 20, 20].max
        @handle.set_size hw, sh
        @handle.set_xy (w - hw) * @value, 0
      end
    end

    class VerticalSlide < Slide

      def initialize
        super

        p0 = self
        @handle = new ShapePad, fill: :gray do
          y0 = 0
          on_mouse_move! do |e|
            if e.drag
              s = sh
              max_y = p0.sh - s
              y0 = sy if e.drag == :start
              start_y = layer&.pin_xy[1]
              y = [[0, y0 + e.y - start_y].max, max_y].min
              p0.value! 1.0 * y / max_y, false
              e.resolve
            end
          end
        end
      end

      def sketch
        super

        w! 10
      end

      def sketch_behavior
        super

        on_mouse_down! :primary do |e|
          @handle.drag! @handle.translate(0, @handle.sh * 0.5), :primary
          e.resolve
          e.break
        end
      end

      def arrange lh = nil
        h = clh
        lh ||= 3 * h
        hh = (h.to_f / lh * h).clamp 20, [h - 20, 20].max
        @handle.set_size sw, hh
        @handle.set_xy 0, (h - hh) * @value
      end
    end
  end
end