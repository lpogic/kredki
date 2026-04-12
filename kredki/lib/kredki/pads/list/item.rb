module Kredki
  module Pads
    module List
      # List item model.
      class Item < ItemY

        # Set whether is selected.
        def set_selected value = true, &block
          return if (c = selected) == (value = block ? block[c] : value == Not ? !c : value)
          @selected = value
          repaint
          true
        end

        # See #set_selected.
        def selected= param
          send_bundle :set_selected, param
        end

        # Get whether is selected.
        def selected
          @selected
        end

        # Set suit.
        def set_suit *suit
          return send_bundle :set_suit, yield(self.suit) if block_given?
          suit = Util.uncover suit
          return if @suit == suit && suit != :random
          @suit = suit
          repaint
          true
        end

        # See #set_suit.
        def suit= param
          send_bundle :set_suit, param
        end

        # Get suit.
        def suit
          @suit
        end

        # :section: LEVEL 2

        def presence
          super

          Event.each(
            on_focus_enter,
            on_focus_leave,
            on_mouse_press,
            on_mouse_release,
            on_mouse_enter,
            on_mouse_leave,
            do: method(:repaint)
          )
        end

        def repaint event = nil
          color = Kredki.color @suit

          if in_disabled
            set_opacity 3/4r
            area.set_fill color
            area.set_stroke_width 0
            area.set_stroke_fill color
          else
            set_opacity 1r
            area.set_fill selected ? mouse_in ? Kredki.color(:text_selection).lighten : :text_selection : mouse_in ? color.lighten : color
            if keyboard_in
              area.set_stroke_width 1
              area.set_stroke_fill :stroke_focus
            else
              area.set_stroke_width 0
              area.set_stroke_fill color
            end
          end
        end

        def behavior
          super

          on_key_press :up do |e|
            set_selected if e.shift?
            item = lower.focus_previous
            if item
              item.set_selected if e.shift?
              item.request_vision
            end
            e.close
          end

          on_key_press :down do |e|
            set_selected if e.shift?
            item = lower.focus_next
            if item
              item.set_selected if e.shift?
              item.request_vision
            end
            e.close
          end
        end

        def mouse_enter e
        end

        def mouse_press e
          lower.select_up_to self if Kredki.keyboard.mod_pass? shift: true
          super
        end

      end#Item
    end#List
  end#Pads
end#Kredki
