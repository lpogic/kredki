module Kredki
  module UI
    # Part of X axis aligned item group.
    class XItem < Item
      # :section: LEVEL 2

      def behavior
        super

        on_key_press! :left do |e|
          parent.update_selected_item(:previous)&.roi!
          e.resolve
        end

        on_key_press! :right do |e|
          parent.update_selected_item(:next)&.roi!
          e.resolve
        end
      end
    end
  end
end
