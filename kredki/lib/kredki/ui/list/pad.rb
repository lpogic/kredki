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
        
        # Create and attach pick event reaction.
        def on_pick ...
          on(Item::PickEvent, ...)
        end

        # See #on_pick.
        def on_pick= param
          on_pick do: param
        end

        # :section: LEVEL 2

        def sketch
          super

          keyboardy!
          fill! :gray
          layout! :yss
          h! :fit

          @item_group = new ItemGroup
        end

        def behavior
          super

          on Item::PickEvent do |e|
            item = e.target
            kb = Kredki.keyboard
            if kb.shift?
              item.selected!
            elsif kb.ctrl?
              item.selected! :not
            else
              each_fd(Item).each_alter{|it| selected! it == item }
            end
          end

          on_focus_leave do
            each_fd(Item).each_alter selected: false
          end
        end

      end#Pad
    end#List
  end#UI
end#Kredki