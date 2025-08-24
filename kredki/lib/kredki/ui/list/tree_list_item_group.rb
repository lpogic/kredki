module Kredki
  module UI
    class TreeListItemGroup < ItemGroup

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

      def update_select_item item
        case item
        when :previous
          items = self[Item...].to_a 
          index = items.index{ it.keyboard_in? } || 1
          update_select_item items[index - 1] if index > 0
        when :next
          found = nil
          self[Item...].any? do
            if found
              break update_select_item it if it.show?
            elsif it.keyboard_in?
              found = it
            end
            false
          end or found or self[Item]&.then{ update_select_item it }
          # items = self[Item...].to_a 
          # index = items.index{ it.keyboard_in? } || -1
          # update_select_item items[index + 1] if index < items.length - 1
        else
          item&.focus!
          item
        end
      end
    end
  end
end