require_relative '../context/menu'
require_relative 'layer'
require_relative 'primary_layer'
require_relative 'item'
require_relative 'item_group'

module Kredki
  module Pads
    module Toolbar
      # Root pad of toolbar menu.
      class Pad < RectanglePad

        # Add menu item.
        def item!(...)
          direct_upper(ItemGroup).item!(...)
        end

        reaction Item::SelectEvent, :on_select

        # :section: LEVEL 2

        def initialize
          super

          set_size 1r, Fit
          set_layout :xsc
          set_fill :gray
        
          put ItemGroup
        end

        def behavior
          super

          on_select do |e|
            if e.target[Context::Item]
              e.close
            else
              keyboard_dispose
            end
          end
        end

      end#Pad
    end#Toolbar
  end#Pads
end#Kredki