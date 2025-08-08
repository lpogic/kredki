require_relative '../item/item_group'

module Kredki
  module UI
    class NoteDropdownLayer < Layer

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
          x + sw * 0.5 - note.area.xs
        end
        @scroll.y = proc do |ph, sh|
          x, y = *note.translate(0, note.sh)
          if y + sh > action.h
            y = [y - sh, 0].max
          end
          y + sh * 0.5 - note.area.ys
        end
        @scroll.w = proc{ note.sw }
        @pad.w = proc do
          pw = parent.sw
          pw -= 10 if @scroll.sh < get_h
          [pw, fit_w].max
        end

        note.action.push_layer self
        @pad[Item]&.focus!
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

      #internal api

      def sketch p0
        super

        @scroll = new ScrollPad
        @pad = @scroll.new Pad, color: :gray, layout: :column, h: :fit
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