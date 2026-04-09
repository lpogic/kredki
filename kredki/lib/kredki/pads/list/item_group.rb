module Kredki
  module Pads
    module List
      # Group of list items.
      class ItemGroup < Pads::ItemGroup

        # Add new item.
        def item!(...)
          put(Item, __method__, ...)
        end

        # :section: LEVEL 2

        def select_up_to pad
          bound = 0
          each_upper(Item).each do |it|
            bound += 1 if it == pad
            bound += 1 if it.keyboard_in
            it.set_selected if bound > 0
            break if bound > 1
          end
        end
      end
    end
  end
end