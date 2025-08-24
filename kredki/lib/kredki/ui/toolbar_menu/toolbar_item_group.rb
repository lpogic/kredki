require_relative '../item/item_group'

module Kredki
  module UI
    class ToolbarItemGroup < ItemGroup
      def item! *a, **na, &b
        new ToolbarItem, *a, w: Fit, **na, &b
      end

      def mouse_enter pad
        pad.focus! if parent.keyboard_in? && self[Item...].find{ it.keyboard_in? } != pad
      end
    end
  end
end