module Kredki
  module Pads
    # Part of X axis aligned item group.
    class ItemX < Item
      
      # :section: LEVEL 2

      def behavior
        super

        on_key_press :left do |e|
          lower.focus_previous&.request_vision
          e.close
        end

        on_key_press :right do |e|
          lower.focus_next&.request_vision
          e.close
        end
      end
    end#ItemX
  end#Pads
end#Kredki
