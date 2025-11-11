require_relative 'tree_list_item_group'
require_relative 'tree_list_item'

module Kredki
  module UI
    class TreeList < ShapePad
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

        @item_group = new TreeListItemGroup
      end

      def sketch_behavior
        super

        on! Item::PickEvent do
          item = it.target
          ke = it.origin
          if false #ke.is_a? KeyboardEvent
            if ke.key.id == :enter
              item.open! :not
            else
              kb = keyboard
              if kb.shift?
                item.select! :not
              else
                s[Item...]{ select! s == item }
              end
            end
          else
            kb = keyboard
            if kb.shift?
              if kb.ctrl?
                item.open! :not
              else
                item.select!
              end
            elsif kb.ctrl?
              item.select! :not
            else
              s[Item..]{ select! s == item }
              item.open! :not
            end
          end
        end

        on_focus_leave! do
          s[Item..] = { select: false }
        end
      end

    end
  end
end