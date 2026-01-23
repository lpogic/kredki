require_relative '../item/item_group'

module Kredki
  module UI
    module Toolbar
      # Toolbar menu item group.
      class ItemGroup < UI::ItemGroup

        # Add menu item.
        def item! *a, **na, &b
          new Item, *a, w: :fit, **na, &b
        end

        # :section: LEVEL 2

        def mouse_enter pad
          pad.keyboard_request if parent.keyboard_in? && fd(Item){|it| it.keyboard_in? } != pad
        end
      end
    end
  end
end