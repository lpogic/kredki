module Kredki
  module UI
    module List
      # List item model.
      class Item < YItem

        # Set whether is selected.
        def selected! value = true, &block
          return if (c = selected) == (value = block ? block[c] : value == :not ? !c : value)
          @selected = value
          repaint
          true
        end

        # See #selected!.
        def selected= param
          send_ahp :selected!, param
        end

        # Get whether is selecteded.
        def selected
          @selected
        end

        # See #selected.
        def selected?
          !!selected
        end

        # Set suit.
        def suit! *suit
          return send_ahp :suit!, yield(self.suit) if block_given?
          suit = Util.uncover suit
          return if @suit == suit && suit != :rand
          @suit = suit
          repaint
          true
        end

        # See #suit!.
        def suit= param
          send_ahp :suit!, param
        end

        # Get suit.
        def suit
          @suit
        end

        # :section: LEVEL 2

        def presence
          super

          Event.each(
            on_focus_enter!,
            on_focus_leave!,
            on_mouse_down!,
            on_mouse_up!,
            on_mouse_enter!,
            on_mouse_leave!,
            do: method(:repaint)
          )
        end

        def repaint event = nil
          color = Kredki.color @suit
          area.fill = selected? ? :text_selection : mouse_in? ? color.lighten : color
            if keyboard_in?
              area.outline_w = 1
              area.outline_fill = :outline_focus
            else
              area.outline_w = 0
              area.outline_fill = color
            end
        end

        def behavior
          super

          on_key_down! :up do |e|
            selected! if e.shift?
            item = parent.update_selected_item(:previous)
            if item
              item.selected! if e.shift?
              item.roi!
            end
            e.resolve
          end

          on_key_down! :down do |e|
            selected! if e.shift?
            item = parent.update_selected_item(:next)
            if item
              item.selected! if e.shift?
              item.roi!
            end
            e.resolve
          end
        end

        def mouse_enter e
        end

        def mouse_down e
          parent.selected_up_to self if Kredki.keyboard.then{ it.shift? && !it.ctrl? }
          super
        end

        def min_w
          @text.fit_w
        end

      end#Item
    end#List
  end#UI
end#Kredki
