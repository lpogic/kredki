module Kredki
  module Pads
    module Radio
      # Radio item button model.
      class ItemButton < RectanglePad

        # Set suit.
        def suit! *suit
          return send_bundle :suit!, yield(self.suit) if block_given?
          suit = Util.uncover suit
          return if @suit == suit && suit != :random
          @suit = suit
          repaint
          true
        end

        # See #suit!.
        def suit= param
          send_bundle :suit!, param
        end

        # Get suit.
        def suit
          @suit
        end
        
        # Set whether is checked.
        def checked! value = true
          return if (c = checked) == (value = block_given? ? yield(c) : value == Not ? !c : value)
          update_checked value
        end

        # See #checked!.
        def checked= param
          send_bundle :checked!, param
        end

        # Get whether is checked.
        def checked
          @checked
        end

        # See #checked.
        def checked?
          !!checked
        end

        class ChangeEvent < Event
          def initialize value
            @value = value
          end

          attr_accessor :value
        end

        def on_change ...
          on(ChangeEvent, ...)
        end

        def on_change= param
          on_change do: param
        end

        # :section: LEVEL 2

        def initialize
          super
          
          @check = put ShapePad, mousy: false, keyboardy: false, fill: :text, size: 1r do
            area! @scene.ellipse!
            hide!
          end
        end

        def sketch
          super

          area! @scene.ellipse!
          keyboardy!
          outline_w! 1
          layout! :zcc
          size! 16
          margin! 3
          suit! :gray
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
          if disabled?
            area.fill! color
            area.outline_fill! color.darken
          else
            area.fill! pin_top? ? color.darken : mouse_in? ? color.lighten : color
            area.outline_fill! keyboard_in? ? :outline_focus : color.darken
          end
        end

        def behavior
          super

          Event.each on_mouse_click, on_key(:space, :enter) do |e|
            report ChangeEvent.new true if !checked
          end

          on_change early: true do |e|
            e.close if disabled? || checked!(e.value).not
          end

          on_key_press do |e|
            find_lower(Group).key e, self
          end
        end

        def update_checked checked
          find_lower(Group)&.set_checked self, checked or set_checked checked
        end

        def set_checked checked
          @checked = checked
          @check.show! checked
        end
      end
    end
  end
end