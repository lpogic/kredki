require_relative '../item/item_group'

module Kredki
  module Pads
    # Layer of option list
    class OptionLayer < Layer

      # Add new item.
      def item! ...
        @item_group.item!(...)
      end

      # :section: LEVEL 2

      def sketch
        super

        @scroll = put ScrollPad, layout: :yss do
          # scene.drop_shadow color: :black # this is too expensive at the moment
        end
        @pad = @scroll.put RectanglePad, fill: :gray, layout: :yss, size_y: Fit
        @item_group = @pad.put ItemGroup
      end

      def behavior
        on Item::PickEvent do |e|
          lower.report e
        end
      end

      def arrange
        @note&.layer&.arrange
        super
      end

      def load note
        @note = note
        @scroll.x = proc do |psx, sx|
          x, y = *note.translate(0, note.area_size_y)
          dsx = window.size_x - sx
          x = [dsx, 0].max if x > dsx
          x
        end
        @scroll.y = proc do |psy, sy|
          x, y = *note.translate(0, note.area_size_y)
          dsy = window.size_y - sy
          y = [dsy, 0].max if y > dsy
          y
        end
        @scroll.size_x = proc{ note.area_size_x }
        @pad.size_x = proc do
          psx = lower.area_size_x
          psx -= 10 if @scroll.area_size_y < @pad.get_size_y
          [psx, fit_size_x].max
        end

        note.pane.put self
        @pad.find_upper(Item)&.keyboard_request
      end

      def unload
        pad_detach
        @note = nil
      end

      def loaded
        !!@note
      end

      def mouse_press e
        unload
      end

      def mouse_release e
      end
    end
  end
end