require_relative '../text_pad'

module Kredki
  module UI
    # Text in rectangle. Part of group.
    class Item < RectanglePad

      # Get text.
      def text
        self[TextPad]
      end

      # Get whether has any item. Overrided in inheriting classes.
      def has_items?
        false
      end

      # Get whether is down.
      def down? keyboard_in = nil
        keyboard_in = keyboard_in? if keyboard_in.nil?
        pin_top? :primary or (
          keyboard_in and (
            Kredki.keyboard.down? :space or
            Kredki.keyboard.down? :enter
          )
        )
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

      # Create and attach pick event resolver.
      def on_pick! ...
        on!(PickEvent, ...)
      end

      # See #on_pick!.
      def on_pick= param
        on_pick! do: param
      end

      # Push the feature.
      def << feature
        case feature
        when String
          text << feature
        else
          super
        end
      end
      
      # :section: LEVEL 2

      class PickEvent < Kredki::UI::Event

        def initialize value, origin
          @value = value
          @origin = origin
        end

        def param
          @value
        end
      end

      def initialize
        super
        
        @text = new TextPad, "", mousy: false
      end

      def sketch
        super

        keyboardy!
        layout! :xsc
        suit! :gray
        h! 24
        w! :fit
      end

      def sketch_presence
        super
        
        Event.each(
          on_focus_enter!,
          on_focus_leave!,
          on_mouse_down!,
          on_mouse_up!,
          on_mouse_enter!,
          on_mouse_leave!,
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @suit
        area.fill = pin_in? ? color.darken : keyboard_in? ? color.lighten : color
      end

      def sketch_behavior
        super

        on_mouse_click! :primary do |e|
          report PickEvent.new(content, e)
        end

        on_key! :space, :enter do |e|
          report PickEvent.new(content, e)
          e.resolve
        end
      end

      def mouse_enter e
        # parent&.mouse_enter self if action.event.is_a? Kredki::UI::PositionEvent
        parent&.mouse_enter self
      end

      def min_w
        @text.fit_w
      end
    end
  end
end
