require_relative 'item'

module Kredki
  module UI
    class YItem < Item
      #internal api

      def sketch p0
        super

        on_key! :up do |e|
          item = parent.update_select_item :previous 
          if item && item != self
            item.roi!
            e.resolve
          end
        end

        on_key! :down do |e|
          item = parent.update_select_item :next
          if item && item != self
            item.roi!
            e.resolve
          end
        end
      end
    end
  end
end
