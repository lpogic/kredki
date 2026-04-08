module Kredki
  module Pads
    # A base class for controls that allows you to set a value by dragging a handle.
    class Slide < RectanglePad

      class EditEvent < Event
        def initialize value, ...
          super(...)
          @value = value
        end

        def value
          @value
        end

        def param
          value
        end
      end

      # Set value.
      def set_value value = @value
        return send_bundle :set_value, yield(self.value) if block_given?
        return if @value == value
        @value = value
        layer&.break_layout
      end

      # See #set_value.
      def value= param
        send_bundle :set_value, param
      end

      # Get value.
      def value
        @value
      end

      # Set suit.
      def set_suit *suit
        return send_bundle :set_suit, yield(self.suit) if block_given?
        suit = Util.uncover suit
        return if @suit == suit && suit != :random
        @suit = suit
        repaint
        true
      end

      # See #set_suit.
      def suit= param
        send_bundle :set_suit, param
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

      # :section: LEVEL 2

      def initialize
        super

        @value = 0.0
        @c0 = 0
        @handle = put RectanglePad, fill: :gray
      end

      attr :handle

      def sketch
        super

        set_suit :gray
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

        if in_disabled
          set_opacity 3/4r
          handle.area.set_fill color.darken
        else
          set_opacity 1r
          handle.area.set_fill mouse_in ? color.lighten : color.darken
        end
      end

      def behavior
        super

        on_mouse_scroll do |e|
          v, y = Kredki.relative_scroll *e.xy
          v = y if v.abs < y.abs
          jump = 0.1
          v = (@value - jump * v).clamp(0..1)
          report EditEvent.new(v, e)
          e.close
        end

        on_mouse_move do |e|
          if e.drag?
            process_drag e
            e.close
          end
        end

        on_edit early: true do |e|
          e.close if in_disabled
        end

        on_edit do |e|
          set_value e.value
        end

        @handle.on_mouse_press do |e|
          @handle.start_drag e.xy, e.button.id
          e.close
        end
      end
    end

    # A control that allows you to set a value by dragging a handle horizontally.
    class HorizontalSlide < Slide

      # :section: LEVEL 2

      def process_drag e, speed = 1
        hsx = @handle.area_size_x
        max_x = area_size_x - hsx
        @c0 = @handle.sx if e.start?
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

    # A control that allows you to set a value by dragging a handle vertically.
    class VerticalSlide < Slide

      # :section: LEVEL 2

      def process_drag e, speed = 1
        hsy = @handle.area_size_y
        max_y = area_size_y - hsy
        @c0 = @handle.sy if e.start?
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