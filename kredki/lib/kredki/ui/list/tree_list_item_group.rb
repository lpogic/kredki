module Kredki
  module UI
    class ListItemGroup < ItemGroup

      def item!(...)
        new(TreeListItem, ...)
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

      def subitems item
        s[ListItem...].drop_while{ it != item }.drop(1).take_while{ it.level > item.level }
      end

      def update_show
        hide_level = 0
        s[ListItem...] do
          if level <= hide_level
            show!
            hide_level = open? ? level + 1 : level
          else
            show! false
          end
        end
      end


    end
  end
end