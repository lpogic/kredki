require_relative '../item/item_group'

module Kredki
  module UI
    module Toolbar
      # Toolbar menu item group.
      class ItemGroup < UI::ItemGroup

        # Add menu item.
        def item! *a, **na, &b
          new ToolbarItem, *a, w: :fit, **na, &b
        end

        # :section: LEVEL 2

        def mouse_enter pad
          pad.keyboard_request if parent.keyboard_in? && self[Item...].find{ it.keyboard_in? } != pad
        end
      end
    end
  end
end