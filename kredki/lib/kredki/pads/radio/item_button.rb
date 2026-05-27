module Kredki
  module Pads
    module Radio
      # Radio item button model.
      class ItemButton < RectanglePad

        feature :suit # Basic apperance
        
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

        feature :selected # Whether radio item is the selected one.

        def set_selected value = true
          return if (c = selected) == (value = value == Not ? !c : value)
          update_group_selected value
        end

        def selected
          @selected
        end

        class SelectEvent < Event
          def initialize value
            @value = value
          end

          attr :value

          def param
            @target.subject
          end
        end

        reaction SelectEvent, :on_select

        # :section: LEVEL 2

        def initialize
          super
          
          @check = default_check 
        end

        def sketch
          super

          set_area @scene.new_ellipse
          set_keyboardy true
          set_stroke_width 1
          set_layout :zcc
          set_size 16
          set_margin 3
          set_suit :gray
        end

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
            area.set fill: color
            area.set stroke_fill: color.darken
          else
            area.set fill: pin_top ? color.darken : mouse_in ? color.lighten : color
            area.set stroke_fill: keyboard_in ? :stroke_focus : color.darken
          end
        end

        def behavior
          super

          Event.each on_mouse_click, on_key(:space, :enter) do |e|
            report SelectEvent.new true if !selected
          end

          on_select early: true do |e|
            e.close if in_disabled || set_selected(e.value).not
          end

          on_key_press do |e|
            lower(Group).key e, self
          end
        end

        def update_group_selected selected
          lower(Group)&.update_selected self, selected or update_selected selected
        end

        def update_selected selected
          @selected = selected
          @check.set_scenic selected
        end

        def default_check
          put ShapePad, mousy: false, keyboardy: false, fill: :text, size: 1r do
            set_area @scene.new_ellipse
            set_scenic false
          end
        end

      end
    end
  end
end