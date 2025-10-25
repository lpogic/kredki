module Kredki
  module UI
    class RadioItem < ShapePad
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

      flag def checked! value = true, &block
        return if (c = checked) == (value = block ? block[c] : value == :not ? !c : value)
        update_checked value
      end

      #internal api

      def initialize
        super
        
        @check = new ShapePad, mousy: false, keyboardy: false, color: :text, wh: 1r do
          area! do |w, h|
            ellipse! w, h
          end
          hide!
        end
      end

      def sketch p0
        super

        area! do |w, h|
          ellipse! w - 1, h - 1
        end
        keyboardy!
        stroke_size! 1
        layout! :acc
        wh! 16
        m! 4
        color! :gray

        theme
        drive
      end

      def drive
        Event.each on_mouse_click!, on_key!(:space, :enter) do
          checked!
        end

        on_key_down! do |e|
          parent.key e, self
        end
      end

      def update_checked checked
        parent&.set_checked self, checked or set_checked checked
      end

      def set_checked checked
        @checked = checked
        @check.show! checked
      end
    end
  end
end