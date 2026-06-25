require_relative 'option_item_group'

module Kredki
  module Pads
    # Layer of option list
    class OptionLayer < Layer

      # Add new item.
      def item! ...
        @item_group.item!(...)
      end

      # :section: LEVEL 2

      def initialize
        super

        @scroll = put ScrollPad, layout: :yss do
          # scene.drop_shadow color: :black # this is too expensive at the moment
        end
        @pad = @scroll.put RectanglePad, fill: :gray, layout: :yss, size_y: Fit
        @item_group = @pad.put OptionItemGroup
      end

      def behavior
        super

        on_key_press :escape do |e|
          unload
          e.close
        end
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
        @scroll.set_size_x sx
        @scroll.set_xy x, y

        psx = sx
        psx -= 10 if @scroll.area_size_y < @pad.get_size_y
        @pad.set_size_x [psx, @pad.fit_size_x].max

        super
      end

      def load note
        @note = note
        note.pane.put self
        @pad[Item]&.keyboard_request
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