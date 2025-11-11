require_relative 'list_item_group'
require_relative 'list_item'

module Kredki
  module UI
    class List < ShapePad
      extend HasEventResolvers

      event_resolver :on_pick!, Item::PickEvent

      def item! *a, **na, &b
        @item_group.item! *a, w: 1r, **na, &b
      end

      #internal api

      def sketch
        super

        keyboardy!
        fill! :gray
        layout! :ybb
        h! :fit

        @item_group = new ListItemGroup
      end

      def sketch_behavior
        super

        on! Item::PickEvent do
          item = it.target
          kb = keyboard
          if kb.shift?
            item.select!
          elsif kb.ctrl?
            item.select! :not
          else
            s[Item..]{ select! s == item }
          end
        end

        on_focus_leave! do
          s[Item..] = { select: false }
        end
      end

    end
  end
end