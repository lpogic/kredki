module Kredki
  module UI
    module Radio
      # Radio item button model.
      class ItemButton < RectanglePad

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
        
        # Set whether is checked.
        def checked! value = true
          return if (c = checked) == (value = block_given? ? yield(c) : value == :not ? !c : value)
          update_checked value
        end

        # See #checked!.
        def checked= param
          send_ahp :checked!, param
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
          
          @check = new RectanglePad, mousy: false, keyboardy: false, fill: :text, wh: 1r do
            area! do |w, h|
              ellipse! w, h
            end
            hide!
          end
        end

        def sketch
          super

          area! do |w, h|
            ellipse! w - 1, h - 1
          end
          keyboardy!
          outline_w! 1
          layout! :zcc
          wh! 20
          m! 4
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
          area.fill = pin_top? ? color.darken : mouse_in? ? color.lighten : color
          area.outline_fill = keyboard_in? ? :outline_focus : color.darken
        end

        def behavior
          super

          Event.each on_mouse_click, on_key(:space, :enter) do |e|
            report ChangeEvent.new true if !checked
          end

          on_change early: true do |e|
            e.close unless checked! e.value
          end

          on_key_press do |e|
            fa(Group).key e, self
          end
        end

        def update_checked checked
          fa(Group)&.set_checked self, checked or set_checked checked
        end

        def set_checked checked
          @checked = checked
          @check.show! checked
        end
      end
    end
  end
end