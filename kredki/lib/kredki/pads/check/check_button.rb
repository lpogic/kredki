module Kredki
  module Pads
    # Control which state can be on or off.
    class CheckButton < Button

      # Set whether is checked.
      def checked! value = true
        return if (c = checked) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @check.show! value
        @checked = value
        true
      end

      # See #checked!.
      def checked= param
        send_bundle :checked!, param
      end

      # Get whether is checked.
      def checked
        @checked
      end

      # See #checked.
      def checked?
        !!checked
      end

      # :section: LEVEL 2

      def initialize
        super
        
        @check = new RectanglePad, mousy: false, keyboardy: false, fill: 0, wh: 1r do
          outline! fill: :text, w: 3
          area! do |w, h|
            xy! 3, 1/2r
            line! 1/2r, -3
            line! -3, 3
          end
          hide!
        end
      end

      def sketch
        super

        layout! :zcc
        wh! 16
        m! 2
      end

      def repaint event = nil
        color = Kredki.color @suit
        if disabled?
          area.fill! color
          area.outline_fill! color.darken
        else
          area.fill! pressed? ? color.darken : mouse_in? ? color.lighten : color
          area.outline_fill! keyboard_in? ? :outline_focus : color.darken
        end
      end

    end
  end
end