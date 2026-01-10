require_relative 'text_pad'

module Kredki
  module UI
    class Button < RectanglePad

      # Create and attach button click event resolver.
      def on_click! ...
        on!(ButtonClickEvent, ...)
      end

      def on_click= param
        on_click! do: param
      end

      # Set whether is down.
      def down! value = true, event = nil
        return if (c = down) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        @down = value
        report (@down ? ButtonDownEvent.new(event) : MouseButtonFreeEvent.new(event)) if event
        true
      end

      # See #down!.
      def down= param
        send_ahp :down!, param
      end

      # Get whether is down.
      def down
        @down
      end

      # See #down.
      def down?
        !!down
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
          (fc TextPad or default_text) << arg
        else
          super
        end
      end

      # :section: LEVEL 2

      class ButtonClickEvent < Event
      end

      class ButtonDownEvent < Event
      end

      class MouseButtonFreeEvent < Event
      end

      def sketch
        super

        keyboardy!
        outline_w! 1
        layout! :acc
        wh! :fit
        suit! :gray
        m! 3
      end

      def presence
        super

        Event.each(
          on_focus_enter!, 
          on_focus_leave!, 
          on_mouse_enter!, 
          on_mouse_leave!, 
          on!(ButtonDownEvent), 
          on!(MouseButtonFreeEvent),
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @suit
        area.fill = down? ? color.darken : mouse_in? ? color.lighten : color
        area.outline_fill = keyboard_in? ? :outline_focus : color.darken
      end

      def behavior
        super

        Event.each on_mouse_press!(:primary), on_key_press!(:enter, :space) do |e|
          down! true, e
        end

        on_focus_leave! do |e|
          down! false, e
        end

        on_mouse_click! :primary do |e|
          down = keyboard_in? && ( Kredki.keyboard.down?(:space) || Kredki.keyboard.down?(:enter) )
          
          report ButtonClickEvent.new e if !down && down!(false, e)
        end

        # on_mouse_free! :primary do |e|
        #   down = keyboard_in? && ( Kredki.keyboard.down?(:space) || Kredki.keyboard.down?(:enter) )
        #   report ButtonClickEvent.new e if !down && down!(false, e) && !e.drag && include_point?(*layer.translate(*e.xy, self))
        # end

        on_key_free! :enter do |e|
          down = pin_top?(:primary) || ( keyboard_in? && Kredki.keyboard.down?(:space) )
          report ButtonClickEvent.new e if !down && down!(false, e)
        end

        on_key_free! :space do |e|
          down = pin_top?(:primary) || ( keyboard_in? && Kredki.keyboard.down?(:enter) )
          report ButtonClickEvent.new e if !down && down!(false, e)
        end
      end

      def default_text
        new TextPad, "Button" do
          mousy! false
          h! :fit
          verse_size! 24
          verse_layout! :ycc
        end
      end
    end
  end
end