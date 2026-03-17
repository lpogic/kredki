module Kredki
  module Pads
    module List
      # Group of list items.
      class ItemGroup < Pads::ItemGroup

        # Add new item.
        def item!(...)
          put(Item, :item!, ...)
        end

        # :section: LEVEL 2

        def selected_up_to pad
          bound = 0
          each_upper(Item).each_set do
            bound += 1 if self == pad
            bound += 1 if keyboard_in?
            set_selected if bound > 0
            break if bound > 1
          end
        end
      end
    end
  end
end