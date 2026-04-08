module Kredki
  module Pads
    module Radio
      # Radio item button model.
      class ItemButton < RectanglePad

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
        
        # Set whether is selected.
        def set_selected value = true
          return if (c = selected) == (value = block_given? ? yield(c) : value == Not ? !c : value)
          update_group_selected value
        end

        # See #set_selected.
        def selected= param
          send_bundle :set_selected, param
        end

        # Get whether is selected.
        def selected
          @selected
        end

        # See #selected.
        def selected?
          !!selected
        end

        class SelectEvent < Event
          def initialize value
            @value = value
          end

          attr_accessor :value
        end

        def on_select ...
          on(SelectEvent, ...)
        end

        def on_select= param
          on_select do: param
        end

        # :section: LEVEL 2

        def initialize
          super
          
          @check = put ShapePad, mousy: false, keyboardy: false, fill: :text, size: 1r do
            set_area @scene.new_ellipse
            set_scenic false
          end
        end

        def sketch
          super

          set area: @scene.new_ellipse
          set keyboardy: true
          set stroke_width: 1
          set layout: :zcc
          set size: 16
          set margin: 3
          set suit: :gray
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
            find_lower(Group).key e, self
          end
        end

        def update_group_selected selected
          find_lower(Group)&.update_selected self, selected or update_selected selected
        end

        def update_selected selected
          @selected = selected
          @check.set_scenic selected
        end
      end
    end
  end
end