require_relative 'item'

module Kredki
  module Pads
    # Part of Y axis aligned item group.
    class YItem < Item
      
      # :section: LEVEL 2

      def behavior
        super

        on_key_press :up do |e|
          item = lower.update_selected_item :previous 
          if item
            item.request_vision
            e.close
          end
        end

        on_key_press :down do |e|
          item = lower.update_selected_item :next
          if item
            item.request_vision
            e.close
          end
        end
      end
    end
  end
end
