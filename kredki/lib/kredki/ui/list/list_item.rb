module Kredki
  module UI
    class ListItem < YItem
      extend HasEventResolvers

      feature def fill! *fill
        fill = Util.uncover fill
        return if @fill == fill
        @fill = fill
        repaint
        true
      end

      flag def select! value = true, &block
        return if (c = select) == (value = block ? block[c] : value == :not ? !c : value)
        @select = value
        repaint
        true
      end

      # :section: LEVEL 2

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
        area.fill = select? ? :text_selection : mouse_in? ? color.lighten : color
          if keyboard_in?
            area.outline_w = 1
            area.outline_fill = :outline_focus
          else
            area.outline_w = 0
            area.outline_fill = color
          end
      end

      def sketch_behavior
        super

        on_key_down! :up do |e|
          select! if e.shift?
          item = parent.update_select_item(:previous)
          if item
            item.select! if e.shift?
            item.roi!
          end
          e.resolve
        end

        on_key_down! :down do |e|
          select! if e.shift?
          item = parent.update_select_item(:next)
          if item
            item.select! if e.shift?
            item.roi!
          end
          e.resolve
        end
      end

      def mouse_enter e
      end

      def mouse_down e
        parent.select_up_to self if Kredki.keyboard.then{ it.shift? && !it.ctrl? }
        super
      end

      def min_w
        @text.fit_w
      end

    end
  end
end
