module Kredki
  module Pads
    # Layer of option list
    class ColorPickerLayer < Layer

      # Add new item.
      def item! ...
        @item_group.item!(...)
      end

      # :section: LEVEL 2

      def initialize
        super

        @pad = put ColorPickerPad
      end

      def behavior
        super

        on_key_press :escape do |e|
          unload
          e.close
        end
      end

      def arrange
        @note&.layer&.arrange
        super
      end

      def load note
        @note = note
        @pad.x = proc do |psx, sx|
          x, y = *note.translate(0, note.area_size_y)
          dsx = window.size_x - sx
          x = [dsx, 0].max if x > dsx
          x
        end
        @pad.y = proc do |psy, sy|
          x, y = *note.translate(0, note.area_size_y)
          dsy = window.size_y - sy
          y = [dsy, 0].max if y > dsy
          y
        end
        @pad.size_x = proc{ note.area_size_x }

        note.pane.put self
      end

      def unload
        pad_detach
        @note = nil
      end

      def loaded
        !!@note
      end

      def mouse_press e
        # unload
      end

      def mouse_release e
      end
    end
  end
end