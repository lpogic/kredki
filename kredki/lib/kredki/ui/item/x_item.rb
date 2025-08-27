module Kredki
  module UI
    class XItem < Item
      #internal api

      def sketch p0
        super

        on_key! :left do |e|
          parent.update_select_item(:previous)&.roi!
          e.resolve
        end

        on_key! :right do |e|
          parent.update_select_item(:next)&.roi!
          e.resolve
        end
      end
    end
  end
end
