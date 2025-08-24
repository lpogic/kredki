require_relative 'tree_list_item_group'
require_relative 'tree_list_item'

module Kredki
  module UI
    class TreeList < ShapePad
      extend Forwardable
      extend HasParams
      extend HasEventResolvers

      event_resolver :on_pick!, Item::PickEvent

      def item! *a, **na, &b
        @item_group.item! *a, w: 1r, **na, &b
      end

      #internal api

      def sketch p0
        super

        keyboardy!
        color! :gray
        layout! Y/Begin/Begin

        @item_group = new TreeListItemGroup

        on! Item::PickEvent do
          item = it.target
          ke = it.origin
          if false #ke.is_a? KeyboardEvent
            if ke.key.id == :enter
              item.open! :~
            else
              kb = keyboard
              if kb.shift?
                item.select! :~
              else
                s[Item...]{ select! s == item }
              end
            end
          else
            kb = keyboard
            if kb.shift?
              if kb.ctrl?
                item.open! :~
              else
                item.select!
              end
            elsif kb.ctrl?
              item.select! :~
            else
              s[Item..]{ select! s == item }
              item.open! :~
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