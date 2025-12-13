module Kredki
  module UI
    # Part of X axis aligned item group.
    class XItem < Item
      # :section: LEVEL 2

      def sketch_behavior
        super

        on_key! :left do |e|
          parent.update_selected_item(:previous)&.roi!
          e.resolve
        end

        on_key! :right do |e|
          parent.update_selected_item(:next)&.roi!
          e.resolve
        end
      end
    end
  end
end
