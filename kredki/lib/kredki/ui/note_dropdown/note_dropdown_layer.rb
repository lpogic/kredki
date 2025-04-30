require_relative '../option/option_group'

module Kredki
  module UI
    class NoteDropdownLayer < Layer

      def load! note
        x, y = *note.translate(0, note.sh)
        if x + @scroll.sw > action.w
          x = [action.w - @scroll.sw, 0].max
        end
        if y + @scroll.h > action.h
          y = [y - @scroll.sh, 0].max
        end
        pw = mw = note.sw
        pw -= 10 if @scroll.sh < @pad.sh
        options = @scroll[Option..].to_a
        w = [pw, *options.map{ it.pw true }].max
        @pad.alter do
          options.each{ it.w = w }
        end
        @scroll.alter do
          xy! x, y
          w! mw
        end.attach! self
        action.push_layer self
        @scroll[Option]&.focus!
      end

      def unload!
        pad_detach
      end

      def loaded?
        !!@pad_parent
      end

      def option! ...
        @pad.option!(...)
      end

      #internal api

      def initialize
        super
      end

      def sketch p0
        super
        
        @scroll = new_pad ScrollPad, w: :fit
        @pad = @scroll.new_pad Pad, wh: :fit, color: :gray, layout: :column        
      end

      def mouse_button_down e
        unload!
      end

      def mouse_button_up e
      end
    end
  end
end