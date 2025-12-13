module Kredki
  module UI
    class Check < RectanglePad

      feature def fill! *fill
        return send_ahp :fill!, yield(self.fill) if block_given?
        fill = Util.uncover fill
        return if @fill == fill && fill != :rand
        @fill = fill
        repaint
        true
      end

      flag def checked! value = true
        return if (c = checked) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        set_checked value
        @checked = value
        true
      end

      # :section: LEVEL 2

      def initialize
        super
        
        @check = new RectanglePad, mousy: false, keyboardy: false, fill: 0, wh: 1r do
          out! fill: :text, w: 3
          outline_fill! :text
          outline_w! 3
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
        fill! :gray
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
        color = Kredki.color @fill
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