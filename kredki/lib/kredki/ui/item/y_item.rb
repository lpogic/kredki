require_relative 'item'

module Kredki
  module UI
    # Part of Y axis aligned item group.
    class YItem < Item
      
      # :section: LEVEL 2

      def behavior
        super

        on_key! :up do |e|
          item = parent.update_selected_item :previous 
          if item && item != self
            item.roi!
            e.resolve
          end
        end

        on_key! :down do |e|
          item = parent.update_selected_item :next
          if item && item != self
            item.roi!
            e.resolve
          end
        end
      end
    end
  end
end
