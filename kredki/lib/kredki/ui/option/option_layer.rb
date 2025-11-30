require_relative '../item/item_group'

module Kredki
  module UI
    class OptionLayer < Layer

      def arrange
        @note&.layer&.arrange
        super
      end

      def load! note
        @note = note
        @scroll.x = proc do |pw, sw|
          x, y = *note.translate(0, note.sh)
          if x + sw > action.w
            x = [action.w - sw, 0].max
          end
          x
        end
        @scroll.y = proc do |ph, sh|
          x, y = *note.translate(0, note.sh)
          if y + sh > action.h
            y = [y - sh, 0].max
          end
          y
        end
        @scroll.w = proc{ note.sw }
        @pad.w = proc do
          pw = parent.sw
          pw -= 10 if @scroll.sh < @pad.get_h
          [pw, fit_w].max
        end

        note.action.push_layer self
        @pad[Item]&.keyboard_request
      end

      def unload!
        pad_detach
        @note = nil
      end

      def loaded?
        !!@note
      end

      def item! ...
        @item_group.item!(...)
      end

      # :section: LEVEL 2

      def sketch
        super

        @scroll = new ScrollPad, layout: :ybb
        @pad = @scroll.new ShapePad, fill: :gray, layout: :ybb, h: :fit
        @item_group = @pad.new ItemGroup
      end

      def mouse_down e
        unload!
      end

      def mouse_up e
      end
    end
  end
end