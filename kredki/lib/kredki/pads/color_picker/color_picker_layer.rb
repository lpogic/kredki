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

        Event.each(
          (on_mouse_move early: true),
          (on_mouse_update early: true),
          (on_mouse_press early: true),
          (on_mouse_release early: true),
        ) do |e|
          e.close self if close_event_check e
        end
        
        on_mouse_move always: true do |e|
          e.close e.closer != self
        end

        on_mouse_update always: true do |e|
          e.close e.closer != self
        end

        on_mouse_press always: true do |e|
          if e.closer == self
            e.close false
          elsif !e.closed
            unload
          end
        end

        on_mouse_release always: true do |e|
          if e.closer == self
            e.close false
          end
        end
      end

      def close_event_check e
        @note.pin_in || (!pin_in && @note.include_point(*@note.pane.translate(*e.xy, @note)))
      end

      def arrange
        return unless @layout_broken
        @note&.layer&.arrange

        sx, sy = @note.area_size
        x, y = @note.translate 0, sy        
        dsx = window.size_x - sx
        x = [dsx, 0].max if x > dsx
        dsy = window.size_y - sy
        y = [dsy, 0].max if y > dsy
        @pad.set_size_x sx
        @pad.set_xy x, y

        super
      end

      def load note
        @note = note
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
      end

      def mouse_release e
      end

      def mouse_move e
      end
    end
  end
end