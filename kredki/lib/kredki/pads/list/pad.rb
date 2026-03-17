require_relative 'item_group'
require_relative 'item'

module Kredki
  module Pads
    module List
      class Pad < RectanglePad
        
        # Add new item.
        def item! *a, **ka, &b
          @item_group.item! *a, size_x: 1r, **ka, &b
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

          set keyboardy: true
          set fill: :gray
          set layout: :yss
          set size_y: Fit

          @item_group = put ItemGroup
        end

        def behavior
          super

          on Item::PickEvent do |e|
            item = e.target
            kb = Kredki.keyboard
            if kb.shift?
              item.set_selected
            elsif kb.ctrl?
              item.set_selected Not
            else
              each_upper(Item).each_set{|it| set_selected it == item }
            end
          end

          on_focus_leave do
            each_upper(Item).each_set selected: false
          end
        end

      end#Pad
    end#List
  end#Pads
end#Kredki