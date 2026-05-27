module Kredki
  module Pads
    module List
      # List item model.
      class Item < ItemY

        feature :selected
        
        def set_selected value = true
          return if (c = selected) == (value = value == Not ? !c : value)
          @selected = value
          repaint
          true
        end
        
        def selected
          @selected
        end

        feature :suit # Basic appearance.

        def set_suit *suit
          suit = Util.uncover suit
          return if @suit == suit && suit != :random
          @suit = suit
          repaint
          true
        end
        
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

        def repaint event = nil, keyboard_in_lower = nil
          color = Kredki.color @suit

          if in_disabled
            set_opacity 3/4r
            area.set_fill color
            area.set_stroke_width 0
            area.set_stroke_fill color
          else
            set_opacity 1r

            if selected 
              keyboard_in_lower = lower_pad&.keyboard_in || false if keyboard_in_lower.nil?
              if mouse_in
                area.set_fill Kredki.color(keyboard_in_lower ? :text_selection : :text_selection_inactive).lighten
              else
                area.set_fill keyboard_in_lower ? :text_selection : :text_selection_inactive
              end
            else
              area.set_fill mouse_in ? color.lighten : color
            end

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
          lower.select_up_to self if Kredki.keyboard.match shift: true
          super
        end

      end#Item
    end#List
  end#Pads
end#Kredki
