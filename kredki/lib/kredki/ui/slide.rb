module Kredki
  module UI
    # A base class for controls that allows you to set a value by dragging a handle.
    class Slide < RectanglePad

      class EditEvent < Event
      end

      class ChangeEvent < Event
      end

      # Set value.
      def value! value = @value
        return send_ahp :value!, yield(self.value) if block_given?
        return if @value == value
        @value = value
        layer&.break_layout
      end

      # See #value!.
      def value= param
        send_ahp :value!, param
      end

      # Get value.
      def value
        @value
      end

      # Set suit.
      def suit! *suit
        return send_ahp :suit!, yield(self.suit) if block_given?
        suit = Util.uncover suit
        return if @suit == suit && suit != :rand
        @suit = suit
        repaint
        true
      end

      # See #suit!.
      def suit= param
        send_ahp :suit!, param
      end

      # Get suit.
      def suit
        @suit
      end

      # Create and attach edit event reaction.
      def on_edit ...
        on(EditEvent, ...)
      end

      # See #on_edit.
      def on_edit= param
        on_edit do: param
      end

      # Create and attach change event reaction.
      def on_change ...
        on(ChangeEvent, ...)
      end

      # See #on_change.
      def on_change= param
        on_change do: param
      end

      # :section: LEVEL 2

      def initialize
        super

        @value = 0.0
      end

      attr :handle

      def sketch
        super

        suit! :gray
      end

      def presence
        super

        Event.each(
          on_mouse_press, 
          on_mouse_release, 
          on_mouse_enter, 
          on_mouse_leave,
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @suit
        handle.area.fill = mouse_in? ? color.lighten : color.darken
      end

      def behavior
        super 

        on_mouse_scroll do |e|
          jump = Kredki.keyboard.alt? ? Kredki.mouse.wheel_alt_speed : Kredki.mouse.wheel_speed
          value!{ (it - jump * e.xory).clamp(0..1) } and report EditEvent.new e
          e.close
        end

        p0 = self

        @handle.alter do
          on_mouse_release do |e|
            p0.report ChangeEvent.new
          end

          on_mouse_press do |e|
            drag! e.xy, e.button.id
            e.close
          end
        end
      end
    end

    # A control that allows you to set a value by dragging a handle horizontally.
    class HorizontalSlide < Slide

      # :section: LEVEL 2

      def initialize
        super

        p0 = self
        @handle = new RectanglePad, fill: :gray do
          x0 = 0
          on_mouse_move do |e|
            if e.drag
              s = sw
              max_x = p0.sw - s
              x0 = sx if e.drag == :start
              start_x = layer.pin_xy[0]
              x = [[0, x0 + e.x - start_x].max, max_x].min
              p0.value! 1.0 * x / max_x and p0.report EditEvent.new e
              e.close
            end
          end
        end
      end

      def sketch
        super

        h! 10
      end

      def behavior
        super

        on_mouse_press :primary do |e|
          @handle.drag! @handle.translate(@handle.sw * 0.5, 0), :primary
          e.close
        end
      end

      def arrange lw = nil
        w = clw
        lw ||= 3 * w
        hw = (w.to_f / lw * w).clamp 20, [w - 20, 20].max
        @handle.set_size hw, sh
        @handle.set_xy (w - hw) * @value.to_f.then{ it.nan? ? 0 : it.clamp(0..1) }, 0
      end
    end

    # A control that allows you to set a value by dragging a handle vertically.
    class VerticalSlide < Slide

      # :section: LEVEL 2

      def initialize
        super

        p0 = self
        @handle = new RectanglePad, fill: :gray do
          y0 = 0
          on_mouse_move do |e|
            if e.drag
              s = sh
              max_y = p0.sh - s
              y0 = sy if e.drag == :start
              start_y = layer&.pin_xy[1]
              y = [[0, y0 + e.y - start_y].max, max_y].min
              p0.value! 1.0 * y / max_y and p0.report EditEvent.new e
              e.close
            end
          end
        end
      end

      def sketch
        super

        w! 10
      end

      def behavior
        super

        on_mouse_press :primary do |e|
          @handle.drag! @handle.translate(0, @handle.sh * 0.5), :primary
          e.close
        end
      end

      def arrange lh = nil
        h = clh
        lh ||= 3 * h
        hh = (h.to_f / lh * h).clamp 20, [h - 20, 20].max
        @handle.set_size sw, hh
        @handle.set_xy 0, (h - hh) * @value.to_f.then{ it.nan? ? 0 : it.clamp(0..1) }
      end
    end
  end
end