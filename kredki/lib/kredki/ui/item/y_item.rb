require_relative 'item'

module Kredki
  module UI
    class YItem < Item
      #internal api

      def sketch p0
        super

        on_key_down! :up do |e|
          parent.update_select_item(:previous)&.roi!
          e.resolve
        end

        on_key_down! :down do |e|
          parent.update_select_item(:next)&.roi!
          e.resolve
        end
      end
    end
  end
end
