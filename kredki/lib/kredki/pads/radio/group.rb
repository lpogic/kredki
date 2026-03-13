require_relative 'item_button'
require_relative 'item'

module Kredki
  module Pads
    module Radio
      # Group of radio items.
      class Group < Service

        # Add new radio item.
        def item! ...
          put(Item, :item!, ...)
        end

        # :section: LEVEL 2

        def key event, item_button
          case event.key.id
          when :up
            previous_item_button(item_button).keyboard_request
            event.close
          when :down
            next_item_button(item_button).keyboard_request
            event.close
          end
        end

        def previous_item_button item_button
          item_buttons = each_upper(ItemButton).to_a
          item_buttons[item_buttons.index(item_button) - 1]
        end

        def next_item_button item_button
          item_buttons = each_upper(ItemButton).to_a
          item_buttons[(item_buttons.index(item_button) + 1) % item_buttons.size]
        end

        def set_checked item_button, checked
          each_upper(ItemButton){|it| it.checked? }.each{|it| it.set_checked false } if checked
          item_button.set_checked checked
        end
      end#Group
    end#Radio
  end#Pads
end#Kredki