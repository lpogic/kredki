require_relative '../item/item_group'
require_relative 'option_item'

module Kredki
  module Pads
    # Group of items.
    class OptionItemGroup < ItemGroup

      # Add new item.
      def item!(...)
        put(OptionItem, __method__, ...)
      end
      
    end#OptionItemGroup
  end#Pads
end#Kredki