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
          fc(ItemGroup).item!(...)
        end

        # Create and attach item pick event reaction.
        def on_pick ...
          on(Item::PickEvent, ...)
        end

        # See #on_pick.
        def on_pick= param
          on_pick do: param
        end

        # :section: LEVEL 2

        def initialize
          super

          w! 1r
          h! :fit
          layout! :xsc
          fill! :gray
        
          new ItemGroup
        end

        def behavior
          super

          on_pick do |e|
            keyboard_dispose unless e.target.fd Context::Item
          end
        end

      end#Pad
    end#Toolbar
  end#Pads
end#Kredki