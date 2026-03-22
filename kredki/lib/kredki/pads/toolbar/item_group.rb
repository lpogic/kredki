require_relative '../item/item_group'

module Kredki
  module Pads
    module Toolbar
      # Toolbar menu item group.
      class ItemGroup < Pads::ItemGroup

        # Add menu item.
        def item! *a, **ka, &b
          put Item, :item!, *a, size_x: Fit, **ka, &b
        end

        # :section: LEVEL 2

        def mouse_enter pad
          pad.keyboard_request if lower.keyboard_in && find_upper(Item){|it| it.keyboard_in } != pad
        end
      end
    end
  end
end