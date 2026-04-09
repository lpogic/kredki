module Kredki
  module Pads
    # Control which state can be on or off.
    class CheckboxButton < Button

      # Set whether is selected.
      def set_selected value = true
        return if (c = selected) == (value = block_given? ? yield(c) : value == Not ? !c : value)
        @check.set_scenic value
        @selected = value
        true
      end

      # See #set_selected.
      def selected= param
        send_bundle :set_selected, param
      end

      # Get whether is selected.
      def selected
        @selected
      end

      # :section: LEVEL 2

      def initialize
        super
        
        @check = default_check
      end

      def sketch
        super

        set_layout :zcc
        set_size 16
        set_margin 3
      end

      def repaint event = nil
        color = Kredki.color @suit
        if in_disabled
          area.set_fill color
          area.set_stroke_fill color.darken
        else
          area.set_fill pressed ? color.darken : mouse_in ? color.lighten : color
          area.set_stroke_fill keyboard_in ? :stroke_focus : color.darken
        end
      end

      def default_check
        put RectanglePad, mousy: false, keyboardy: false, fill: 0, size: 1r do
          set_stroke fill: :text, width: 3
          set_area do
            jump 0, 1/2r
            line 1/2r, 1r
            line 1r, 0
          end
          set_scenic false
        end
      end

    end
  end
end