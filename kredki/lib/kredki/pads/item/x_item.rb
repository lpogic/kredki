module Kredki
  module Pads
    # Part of X axis aligned item group.
    class XItem < Item
      # :section: LEVEL 2

      def behavior
        super

        on_key_press :left do |e|
          lower.update_selected_item(:previous)&.roi!
          e.close
        end

        on_key_press :right do |e|
          lower.update_selected_item(:next)&.roi!
          e.close
        end
      end
    end
  end
end
