module Kredki
  module UI
    class Check < ShapePad
      extend Forwardable
      extend HasParams

      param def color! *color
        return color! *Util.cover(yield self.color) if block_given?
        color = Util.uncover color
        return if @color == color
        @color = color
        repaint
        true
      end

      flag def checked! value = true
        return if (c = checked) == (value = block_given? ? yield(c) : value == :not ? !c : value)
        set_checked value
        @checked = value
        true
      end

      #internal api

      def initialize
        super
        
        @check = new ShapePad, mousy: false, keyboardy: false, color: 0, wh: 1r do
          stroke! color: :text, size: 3
          area! do |w, h|
            xy! 2, h * 0.5
            line! w * 0.5, h - 1
            line! w - 2, 2
          end
          hide!
        end
      end

      def sketch p0
        super

        keyboardy!
        stroke_size! 1
        layout! :acc
        wh! 20
        color! :gray
        m! 3

        drive
        theme
      end

      def drive
        Event.each on_mouse_click!, on_key!(:space, :enter) do
          checked! :not
        end
      end

      def theme
        Event.each(
          on_focus_enter!,
          on_focus_leave!,
          on_mouse_down!,
          on_mouse_up!,
          on_mouse_enter!,
          on_mouse_leave!,
        ) do
          repaint
        end
      end

      def repaint
        color = Kredki.color @color
        area.fill_color = pin_top? ? color.darken : mouse_in? ? color.lighten : color
        area.stroke_color = keyboard_in? ? :stroke_focus : color.darken
      end

      def set_checked checked
        @check.show! checked
      end
    end
  end
end