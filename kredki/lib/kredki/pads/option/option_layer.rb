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

        @scroll = new ScrollPad, layout: :yss
        @pad = @scroll.new RectanglePad, fill: :gray, layout: :yss, h: :fit
        @item_group = @pad.new ItemGroup
      end

      def behavior
        on Item::PickEvent do |e|
          parent.report e
        end
      end

      def arrange
        @note&.layer&.arrange
        super
      end

      def load note
        @note = note
        @scroll.x = proc do |pw, sw|
          x, y = *note.translate(0, note.sh)
          w = window.w - sw
          x = [w, 0].max if x > w
          x
        end
        @scroll.y = proc do |ph, sh|
          x, y = *note.translate(0, note.sh)
          h = window.h - sh
          y = [h, 0].max if y > h
          y
        end
        @scroll.w = proc{ note.sw }
        @pad.w = proc do
          pw = parent.sw
          pw -= 10 if @scroll.sh < @pad.get_h
          [pw, fit_w].max
        end

        note.window.push_layer self
        @pad.fd(Item)&.keyboard_request
      end

      def unload
        pad_detach
        @note = nil
      end

      def loaded?
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