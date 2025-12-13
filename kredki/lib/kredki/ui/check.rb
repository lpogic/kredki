module Kredki
  module UI
    # Control which state can be on or off.
    class Check < RectanglePad

      # Set whether is checked.
      def checked! value = true
        return if (c = checked) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        set_checked value
        @checked = value
        true
      end

      # See #checked!.
      def checked= param
        send_ahp :checked!, param
      end

      # Get whether is checked.
      def checked
        @checked
      end

      # See #checked.
      def checked?
        !!checked
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

      # :section: LEVEL 2

      def initialize
        super
        
        @check = new RectanglePad, mousy: false, keyboardy: false, fill: 0, wh: 1r do
          outline! fill: :text, w: 3
          area! do |w, h|
            xy! 2, h * 0.5
            line! w * 0.5, h - 1
            line! w - 2, 2
          end
          hide!
        end
      end

      def sketch
        super

        keyboardy!
        outline_w! 1
        layout! :acc
        wh! 20
        suit! :gray
        margin! 3
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
        area.fill = pin_top? ? color.darken : mouse_in? ? color.lighten : color
        area.outline_fill = keyboard_in? ? :outline_focus : color.darken
      end

      def sketch_behavior
        super 

        Event.each on_mouse_click!, on_key!(:space, :enter) do
          checked! :not
        end
      end

      def set_checked checked
        @check.show! checked
      end
    end
  end
end