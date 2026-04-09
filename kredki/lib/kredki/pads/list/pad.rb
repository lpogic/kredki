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
        
        # Create and attach select event reaction.
        def on_select ...
          on(Item::SelectEvent, ...)
        end

        # See #on_select.
        def on_select= param
          on_select do: param
        end

        # :section: LEVEL 2

        def initialize
          super

          @item_group = put ItemGroup
        end

        def sketch
          super

          set_keyboardy true
          set_fill :gray
          set_layout :yss
          set_size_y Fit
        end

        def behavior
          super

          on Item::SelectEvent do |e|
            item = e.target
            kb = Kredki.keyboard
            if kb.shift?
              item.set_selected
            elsif kb.ctrl?
              item.set_selected Not
            else
              each_upper(Item).each{|it| it.set_selected it == item }
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