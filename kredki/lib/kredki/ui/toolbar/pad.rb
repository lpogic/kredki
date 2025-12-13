require_relative '../context/menu'
require_relative 'layer'
require_relative 'primary_layer'
require_relative 'item'
require_relative 'item_group'

module Kredki
  module UI
    module Toolbar
      # Root pad of toolbar menu.
      class Pad < RectanglePad

        # Add menu item.
        def item!(...)
          @item_group.item!(...)
        end

        # Create and attach item pick event resolver.
        def on_pick! ...
          on!(Item::PickEvent, ...)
        end

        # See #on_pick!.
        def on_pick= param
          on_pick! do: param
        end

        # :section: LEVEL 2

        def initialize
          super

          w! 1r
          h! :fit
          xy! 0
          layout! :xsc, 4
          fill! :gray
        
          @item_group = new ToolbarItemGroup

          on_pick! do |e|
            keyboard_dispose unless e.target.has_items?
          end
        end

      end#Pad
    end#Toolbar
  end#UI
end#Kredki