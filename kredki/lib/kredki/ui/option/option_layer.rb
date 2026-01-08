require_relative '../item/item_group'

module Kredki
  module UI
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
        on! Item::PickEvent do |e|
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
        @pad.fd(Item)&.keyboard_request
      end

      def unload
        pad_detach
        @note = nil
      end

      def loaded?
        !!@note
      end

      def mouse_push e
        unload
      end

      def mouse_free e
      end
    end
  end
end