require_relative 'tree_list_item_group'
require_relative 'tree_list_item'

module Kredki
  module UI
    class TreeList < Pad
      extend Forwardable
      extend HasParams
      extend HasEventResolvers

      event_resolver :on_pick!, Item::PickEvent

      def item! *a, **na, &b
        @item_group.item! *a, w: 100r, **na, &b
      end

      #internal api

      def sketch p0
        super

        keyboardy!
        color! :gray
        layout! :ybb

        @item_group = new ListItemGroup

        on! Item::PickEvent do
          item = it.target
          kb = keyboard
          if kb.shift?
            item.select!
          elsif kb.ctrl?
            item.select! :~
          else
            s[Item..]{ select! s == item }
            item.open! :~
          end
        end

        on_focus_leave! do
          s[Item..] = { select: false }
        end
      end

    end
  end
end