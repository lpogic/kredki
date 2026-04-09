module Kredki
  module Pads
    module Tree
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

        def subitems item
          lower.each(Item).drop_while{|it| it.index <= item.index }.take_while{|it| it.level > item.level }
        end

        def update_open
          hide_level = 0
          each_upper(Item).each do |it|
            level = it.level
            if level <= hide_level
              it.set_scenic
              hide_level = it.open ? level + 1 : level
            else
              it.set_scenic false
            end
          end
        end

        def select_previous
          kb = nil
          each_upper(Item, reverse: true).each do |it|
            if kb
              return select it if it.displayed
            elsif it.keyboard_in
              kb = it
            end
          end
          return select kb if kb
          find_upper(Item){|it| it.displayed }&.then{|it| select it }
        end

        def select_next
          kb = nil
          each_upper(Item).each do |it|
            if kb
              return select it if it.displayed
            elsif it.keyboard_in
              kb = it
            end
          end
          return select kb if kb
          find_upper(Item){|it| it.displayed }&.then{|it| select it }
        end

        def select item
          item&.keyboard_request
          item
        end
      end#ItemGroup
    end#Tree
  end#Pads
end#Kredki