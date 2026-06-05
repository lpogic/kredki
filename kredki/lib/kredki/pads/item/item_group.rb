require_relative 'item_y'

module Kredki
  module Pads
    # Group of items.
    class ItemGroup < Service

      # Add new item.
      def item!(...)
        put(ItemY, __method__, ...)
      end
      
      # :section: LEVEL 2

      def mouse_enter pad
        pad.keyboard_request if upper(Item){|it| it.keyboard_in } != pad
      end

      def focus_next
        items = each(Item).to_a 
        index = items.index{|it| it.keyboard_in } || -1
        return items[index] if index >= items.length - 1
        item = (index + 1..items.length - 1).lazy.map{|i| items[i] }.find{|it| !it.in_disabled }
        return items[index] if !item
        focus item
      end

      def focus_previous
        items = each(Item).to_a 
        index = items.index{|it| it.keyboard_in } || 1
        return items[index] if index <= 0
        item = (0..index - 1).lazy.map{|i| items[index - 1 - i]}.find{|it| !it.in_disabled }
        return items[index] if !item
        focus item
      end

      def focus item
        item&.keyboard_request
        item
      end

    end#ItemGroup
  end#Pads
end