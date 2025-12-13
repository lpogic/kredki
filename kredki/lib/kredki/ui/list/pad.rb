require_relative 'item_group'
require_relative 'item'

module Kredki
  module UI
    module List
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

      end#Pad
    end#List
  end#UI
end#Kredki