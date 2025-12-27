module Kredki
  module UI
    module Tree
      class ItemGroup < UI::ItemGroup

        # Add new item.
        def item!(...)
          new(TreeListItem, ...)
        end

        # :section: LEVEL 2

        def selected_up_to pad
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

        def update_selected_item item
          case item
          when :previous
            items = self[Item...].to_a 
            index = items.index{ it.keyboard_in? } || 1
            update_selected_item items[index - 1] if index > 0
          when :next
            found = nil
            self[Item...].any? do
              if found
                break update_selected_item it if it.show?
              elsif it.keyboard_in?
                found = it
              end
              false
            end or found or self[Item]&.then{ update_selected_item it }
            # items = self[Item...].to_a 
            # index = items.index{ it.keyboard_in? } || -1
            # update_selected_item items[index + 1] if index < items.length - 1
          else
            item&.keyboard_request
            item
          end
        end
      end#ItemGroup
    end#Tree
  end#UI
end#Kredki