module Kredki
  module Pads
    # A base class for controls that allows you to set a value by dragging a handle.
    class Slider < RectanglePad

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
  end
end