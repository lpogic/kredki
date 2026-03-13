module Kredki
  module Pads
    # Item group member.
    class Item < RectanglePad

      # Get whether is leaf.
      def leaf?
        true
      end

      # Get whether is pressed.
      def pressed? keyboard_in = nil
        keyboard_in = keyboard_in? if keyboard_in.nil?
        pin_top? :primary or (
          keyboard_in and (
            Kredki.keyboard.pressed? :space or
            Kredki.keyboard.pressed? :enter
          )
        )
      end

      # Set suit.
      def suit! *suit
        return send_bundle :suit!, yield(self.suit) if block_given?
        suit = Util.uncover suit
        return if @suit == suit && suit != :random
        @suit = suit
        repaint
        true
      end

      # See #suit!.
      def suit= param
        send_bundle :suit!, param
      end

      # Get suit.
      def suit
        @suit
      end

      # Create and attach pick event reaction.
      def on_pick ...
        on(PickEvent, ...)
      end

      # See #on_pick.
      def on_pick= param
        on_pick do: param
      end

      # Push the feature.
      def << feature
        case feature
        when String
          subject! feature
          find(TextPad)&.alter feature or default_text feature
          self
        else
          super
        end
      end
      
      # :section: LEVEL 2

      class PickEvent < Event
      end

      def sketch
        super

        keyboardy!
        layout! :xsc
        suit! :gray
        size! Fit, 24
      end

      def presence
        super
        
        Event.each(
          on_focus_enter,
          on_focus_leave,
          on_mouse_press,
          on_mouse_release,
          on_mouse_enter,
          on_mouse_leave,
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @suit
        if disabled?
          opacity! 3/4r
          area.fill! color
        else
          opacity! 1r
          area.fill! pin_in? ? color.darken : keyboard_in? ? color.lighten : color
        end
      end

      def behavior
        super

        on_mouse_click :primary do |e|
          report PickEvent.new e
        end

        on_key :space, :enter do |e|
          report PickEvent.new e
          e.close
        end

        on_pick do |e|
          e.close if disabled?
        end
      end

      def mouse_enter e
        lower&.mouse_enter self
      end

      def min_size_x
        fit_size_x
      end

      def default_text text
        put TextPad, text, mousy: false
      end
    end
  end
end
