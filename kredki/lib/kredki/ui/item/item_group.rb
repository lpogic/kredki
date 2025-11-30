require_relative '../pad/service'
require_relative 'y_item'

module Kredki
  module UI
    class ItemGroup < Service

      def item!(...)
        new(YItem, ...)
      end
      
      # :section: LEVEL 2

      def mouse_enter pad
        pad.keyboard_request if self[Item...].find{ it.keyboard_in? } != pad
      end

      def update_select_item item
        case item
        when :previous
          items = self[Item...].to_a 
          index = items.index{ it.keyboard_in? } || 1
          update_select_item items[index - 1] if index > 0
        when :next
          items = self[Item...].to_a 
          index = items.index{ it.keyboard_in? } || -1
          update_select_item items[index + 1] if index < items.length - 1
        else
          item&.keyboard_request
          item
        end
      end

    end#ItemGroup
  end#UI
end