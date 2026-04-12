module Kredki
  module Pads
    module Tree
      class ItemGroup < Pads::ItemGroup

        # Add new item.
        def item!(...)
          put(Item, __method__, ...)
        end

        # Get all items.
        def items
          each_upper(Tree::Item).to_a
        end

        # Get selected items.
        def selected_items
          each_upper(Tree::Item, selected: true).to_a
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
          each(Item).drop_while{|it| it != item }.drop(1).take_while{|it| it.level > item.level }
        end

        def update_open
          hide_level = 0
          each_upper(Item).each do |it|
            level = it.level
            if level <= hide_level
              it.set_scenic true
              it.set_layoutic true
              hide_level = it.open ? level + 1 : level
            else
              it.set_scenic false
              it.set_layoutic false
              it.update_open false if it.open
            end
          end
        end

        def focus_previous
          kb = nil
          each_upper(Item, reverse: true).each do |it|
            if kb
              return focus it if it.displayed && !it.disabled
            elsif it.keyboard_in
              kb = it
            end
          end
          return focus kb if kb
          find_upper(Item, displayed: true, disabled: false)&.then{|it| focus it }
        end

        def focus_next
          kb = nil
          each_upper(Item).each do |it|
            if kb
              return focus it if it.displayed && !it.disabled
            elsif it.keyboard_in
              kb = it
            end
          end
          return focus kb if kb
          find_upper(Item, displayed: true, disabled: false)&.then{|it| focus it }
        end

        def focus item
          item&.keyboard_request
          item
        end
      end#ItemGroup
    end#Tree
  end#Pads
end#Kredki