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
      def pressed! value = true, event = nil
        return if (c = pressed) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        @pressed = value
        report (@pressed ? ButtonPressEvent.new(event) : ButtonReleaseEvent.new(event)) if event
        true
      end

      # See #pressed!.
      def pressed= param
        send_ahp :pressed!, param
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

      # Push the feature.
      def << arg
        case arg
        when String
          subject! arg
          (c? TextPad or default_text) << arg
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

        keyboardy!
        outline_w! 1
        layout! :xcc
        wh! Fit
        suit! :gray
        m! 2
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
          opacity! 3/4r
          mouse_cursor! nil
          area.fill! color
          area.outline_fill! color.darken
        else
          opacity! 1r
          mouse_cursor! :pointer
          area.fill! pressed? ? color.darken : mouse_in? ? color.lighten : color
          area.outline_fill! keyboard_in? ? :outline_focus : color.darken
        end
      end

      def behavior
        super

        Event.each on_mouse_press(:primary), on_key_press(:enter, :space) do |e|
          pressed! true, e
        end

        on_focus_leave do |e|
          pressed! false, e
        end

        on_mouse_release :primary do |e|
          pressed = keyboard_in? && ( Kredki.keyboard.pressed?(:space) || Kredki.keyboard.pressed?(:enter) )
          report ButtonClickEvent.new e if !pressed && pressed!(false, e) && !e.drag && include_point?(*layer.translate(*e.xy, self))
        end

        on_key_release :enter do |e|
          pressed = pin_top?(:primary) || ( keyboard_in? && Kredki.keyboard.pressed?(:space) )
          report ButtonClickEvent.new e if !pressed && pressed!(false, e)
        end

        on_key_release :space do |e|
          pressed = pin_top?(:primary) || ( keyboard_in? && Kredki.keyboard.pressed?(:enter) )
          report ButtonClickEvent.new e if !pressed && pressed!(false, e)
        end

        on_click early: true do |e|
          e.close if disabled?
        end
      end

      def default_text
        new TextPad, "Button" do
          mousy! false
          h! Fit
          verse_size! Kredki.text_size
          verse_layout! :ycc
        end
      end
    end
  end
end