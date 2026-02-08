require_relative 'y_item'

module Kredki
  module Pads
    # Group of items.
    class ItemGroup < Service

      # Add new item.
      def item!(...)
        new(YItem, :item!, ...)
      end
      
      # :section: LEVEL 2

      def mouse_enter pad
        pad.keyboard_request if d?(Item){|it| it.keyboard_in? } != pad
      end

      def update_selected_item item
        case item
        when :previous
          items = each_c(Item).to_a 
          index = items.index{|it| it.keyboard_in? } || 1
          index > 0 && (item = (0..index - 1).map{|i| items[index - 1 - i]}.find{|i| i.disabled?.not }) ? update_selected_item(item) : items[index]
        when :next
          items = each_c(Item).to_a 
          index = items.index{|it| it.keyboard_in? } || -1
          index < items.length - 1 && (item = (index + 1..items.length - 1).map{|i| items[i]}.find{|i| i.disabled?.not }) ? update_selected_item(item) : items[index]
        else
          item&.keyboard_request
          item
        end
      end

    end#ItemGroup
  end#Pads
end