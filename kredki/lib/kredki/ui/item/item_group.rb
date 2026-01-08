require_relative '../pad/service'
require_relative 'y_item'

module Kredki
  module UI
    # Group of items.
    class ItemGroup < Service

      # Add new item.
      def item!(...)
        new(YItem, ...)
      end
      
      # :section: LEVEL 2

      def mouse_enter pad
        pad.keyboard_request if fd(Item){ it.keyboard_in? } != pad
      end

      def update_selected_item item
        case item
        when :previous
          items = each_fc(Item).to_a 
          index = items.index{ it.keyboard_in? } || 1
          index > 0 ? update_selected_item(items[index - 1]) : items[index]
        when :next
          items = each_fc(Item).to_a 
          index = items.index{ it.keyboard_in? } || -1
          index < items.length - 1 ? update_selected_item(items[index + 1]) : items[index]
        else
          item&.keyboard_request
          item
        end
      end

    end#ItemGroup
  end#UI
end