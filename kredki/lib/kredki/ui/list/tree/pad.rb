require_relative 'item_group'
require_relative 'item'

module Kredki
  module UI
    module Tree
      # Tree list pad.
      class Pad < RectanglePad

        # Add new item.
        def item! *a, **na, &b
          @item_group.item! *a, w: 1r, **na, &b
        end

        # Create and attach pick event resolver.
        def on_pick! ...
          on!(Item::PickEvent, ...)
        end

        # See #on_pick!.
        def on_pick= param
          on_pick! do: param
        end

        # :section: LEVEL 2

        def sketch
          super

          keyboardy!
          fill! :gray
          layout! :yss

          @item_group = new TreeListItemGroup
        end

        def behavior
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

      end#List
    end#Tree
  end#UI
end#Kredki