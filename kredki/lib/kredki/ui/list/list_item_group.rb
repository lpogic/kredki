module Kredki
  module UI
    class ListItemGroup < ItemGroup

      def item!(...)
        new(ListItem, ...)
      end

      def select_up_to pad
        bound = 0
        s[ListItem...] do
          bound += 1 if self == pad
          bound += 1 if keyboard_in?
          select! if bound > 0
          break if bound > 1
        end
      end
    end
  end
end