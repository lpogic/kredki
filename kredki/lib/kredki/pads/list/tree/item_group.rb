module Kredki
  module Pads
    module Tree
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
            bound += 1 if keyboard_in
            set_selected if bound > 0
            break if bound > 1
          end
        end

        def subitems item
          lower.each(Item).drop_while{|it| it.index <= item.index }.take_while{|it| it.level > item.level }
        end

        def update_open
          hide_level = 0
          each_upper(Item).each_set do
            if level <= hide_level
              set_scenic
              hide_level = open? ? level + 1 : level
            else
              set_scenic false
            end
          end
        end

        def update_selected_item item
          case item
          when :previous, :next
            kb = nil
            each_upper(Item, reverse: item == :previous).each do |it|
              if kb
                return update_selected_item it if it.displayed
              elsif it.keyboard_in
                kb = it
              end
            end
            return update_selected_item kb if kb
            find_upper(Item){|it| it.displayed }&.then{|it| update_selected_item it }
          else
            item&.keyboard_request
            item
          end
        end
      end#ItemGroup
    end#Tree
  end#Pads
end#Kredki