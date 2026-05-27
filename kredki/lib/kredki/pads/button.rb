module Kredki
  module Pads
    class Button < RectanglePad

      class PressEvent < Event
      end

      class ReleaseEvent < Event
      end

      class ClickEvent < Event
      end
      
      def mixed_set feature
        case feature
        when String
          self[:text!]&.set feature or super
          self.subject ||= feature
          self
        else
          super
        end
      end

      feature :suit # Basic appearance.
      
      def set_suit *suit
        suit = Util.uncover suit
        return if @suit == suit && suit != :random
        @suit = suit
        repaint
        true
      end

      def suit
        @suit
      end

      feature :pressed # Whether the Button is in pressed state.

      def set_pressed value = true, event = nil
        return if (c = pressed) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @pressed = value
        report (@pressed ? PressEvent.new(event) : ReleaseEvent.new(event)) if event
        true
      end

      def pressed
        !!@pressed
      end

      reaction ClickEvent, :on_click # Reaction to releasing the Button after pressing it.

      def sketch
        super

        set_keyboardy true
        set_stroke_width 1
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
          on(PressEvent), 
          on(ReleaseEvent),
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @suit
        if in_disabled
          set_opacity 3/4r
          set_mouse_cursor nil
          area.set_fill color
          area.set_stroke_fill color.darken
        else
          set_opacity 1r
          set_mouse_cursor :pointer
          area.set_fill pressed ? color.darken : mouse_in ? color.lighten : color
          area.set_stroke_fill keyboard_in ? :stroke_focus : color.darken
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
          pressed = keyboard_in && ( Kredki.keyboard.pressed?(:space) || Kredki.keyboard.pressed?(:enter) )
          report ClickEvent.new e if !pressed && set_pressed(false, e) && !e.drag && include_point(*layer.translate(*e.xy, self))
        end

        on_key_release :space do |e|
          pressed = pin_top(:primary) || ( keyboard_in && Kredki.keyboard.pressed?(:enter) )
          report ClickEvent.new e if !pressed && set_pressed(false, e)
        end

        on_click early: true do |e|
          e.close if in_disabled
        end
      end

      def default_text text
        put TextPad, :text!, text do
          set_mousy false
          set_size_y Fit
          set_verse_size Kredki.text_size
          set_verse_layout :ycc
        end
      end
    end
  end
end