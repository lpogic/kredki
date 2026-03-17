module Kredki
  module Pads
    class Button < RectanglePad

      # Create and attach button click event reaction.
      def on_click ...
        on(ButtonClickEvent, ...)
      end

      def on_click= param
        on_click do: param
      end

      # Set whether is pressed.
      def set_pressed value = true, event = nil
        return if (c = pressed) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @pressed = value
        report (@pressed ? ButtonPressEvent.new(event) : ButtonReleaseEvent.new(event)) if event
        true
      end

      # See #set_pressed.
      def pressed= param
        send_bundle :set_pressed, param
      end

      # Get whether is pressed.
      def pressed
        @pressed
      end

      # See #pressed.
      def pressed?
        !!pressed
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

      # Push the feature.
      def << feature
        case feature
        when String
          set_subject feature
          text?&.set feature or super
        else
          super
        end
      end

      # :section: LEVEL 2

      class ButtonClickEvent < Event
      end

      class ButtonPressEvent < Event
      end

      class ButtonReleaseEvent < Event
      end

      def sketch
        super

        set_keyboardy
        set_outline_w 1
        set_layout :xcc
        set_size Fit
        set_suit :gray
        set_margin 2
      end

      def presence
        super

        Event.each(
          on_focus_enter, 
          on_focus_leave, 
          on_mouse_enter, 
          on_mouse_leave, 
          on(ButtonPressEvent), 
          on(ButtonReleaseEvent),
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @suit
        if disabled?
          set_opacity 3/4r
          set_mouse_cursor nil
          area.set_fill color
          area.set_outline_fill color.darken
        else
          set_opacity 1r
          set_mouse_cursor :pointer
          area.set_fill pressed? ? color.darken : mouse_in? ? color.lighten : color
          area.set_outline_fill keyboard_in? ? :outline_focus : color.darken
        end
      end

      def behavior
        super

        Event.each on_mouse_press(:primary), on_key_press(:enter, :space) do |e|
          set_pressed true, e
        end

        on_focus_leave do |e|
          set_pressed false, e
        end

        on_mouse_release :primary do |e|
          pressed = keyboard_in? && ( Kredki.keyboard.pressed?(:space) || Kredki.keyboard.pressed?(:enter) )
          report ButtonClickEvent.new e if !pressed && set_pressed(false, e) && !e.drag && include_point?(*layer.translate(*e.xy, self))
        end

        on_key_release :enter do |e|
          pressed = pin_top?(:primary) || ( keyboard_in? && Kredki.keyboard.pressed?(:space) )
          report ButtonClickEvent.new e if !pressed && set_pressed(false, e)
        end

        on_key_release :space do |e|
          pressed = pin_top?(:primary) || ( keyboard_in? && Kredki.keyboard.pressed?(:enter) )
          report ButtonClickEvent.new e if !pressed && set_pressed(false, e)
        end

        on_click early: true do |e|
          e.close if disabled?
        end
      end

      def default_text feature
        put TextPad, :text!, feature do
          set_mousy false
          set_size_y Fit
          set_verse_size Kredki.text_size
          set_verse_layout :ycc
        end
      end
    end
  end
end