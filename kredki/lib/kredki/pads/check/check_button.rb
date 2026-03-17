module Kredki
  module Pads
    # Control which state can be on or off.
    class CheckButton < Button

      # Set whether is checked.
      def set_checked value = true
        return if (c = checked) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @check.set_show value
        @checked = value
        true
      end

      # See #set_checked.
      def checked= param
        send_bundle :set_checked, param
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
        
        @check = put RectanglePad, mousy: false, keyboardy: false, fill: 0, size: 1r do
          set_outline fill: :text, w: 3
          set_area do
            xy! 3, 1/2r
            line! 1/2r, -3
            line! -3, 3
          end
          set_show false
        end
      end

      def sketch
        super

        set layout: :zcc
        set size: 16
        set margin: 2
      end

      def repaint event = nil
        color = Kredki.color @suit
        if disabled?
          area.set fill: color
          area.set outline_fill: color.darken
        else
          area.set fill: pressed? ? color.darken : mouse_in? ? color.lighten : color
          area.set outline_fill: keyboard_in? ? :outline_focus : color.darken
        end
      end

    end
  end
end