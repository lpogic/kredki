module Kredki
  module UI
    module Tree
      class ItemGroup < UI::ItemGroup

        # Add new item.
        def item!(...)
          new(Item, ...)
        end

        # :section: LEVEL 2

        def selected_up_to pad
          bound = 0
          find Item... do
            bound += 1 if self == pad
            bound += 1 if keyboard_in?
            selected! if bound > 0
            break if bound > 1
          end
        end

        def subitems item
          self[Item...].drop_while{ it != item }.drop(1).take_while{ it.level > item.level }
        end

        def update_show
          hide_level = 0
          find Item... do
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
          when :previous, :next
            kb = nil
            self[Item..., reverse: item == :previous].each do
              if kb
                return update_selected_item it if it.show?
              elsif it.keyboard_in?
                kb = it
              end
            end
            return update_selected_item kb if kb
            self[Item]{ it.show? }&.then{ update_selected_item it }
          else
            item&.keyboard_request
            item
          end
        end
      end#ItemGroup
    end#Tree
  end#UI
end#Kredki