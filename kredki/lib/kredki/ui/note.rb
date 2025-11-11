require_relative 'text/editable_text_verse'

module Kredki
  module UI
    class Note < ShapePad
      include TextEdition

      param def fill! *fill
        return fill! *Util.cover(yield self.fill) if block_given?
        fill = Util.uncover fill
        return if @fill == fill
        @fill = fill
        repaint
        true
      end

      def << arg
        case arg
        when String
          content! arg
        else
          super
        end
      end

      param_service def cursor
        @verse.cursor
      end

      param def content! string = "", cursor = false
        return content! (yield self.content) if block_given?
        @verse.content! string, cursor
      end, def content
        @verse.content
      end

      param_delegate :@verse,
        :verse,
        :verse_size,
        :verse_layout

      #internal api

      class NoteLayout < Layout::XWay
        def arrange_layoutic pad, clw, clh, cx
          pw = pad.sw
          ph = pad.sh
          px = pad.get_x clw, pw, cx
          py = pad.get_y clh, ph, (get_y @y, clh, ph)
          pad.arrange
          pad.set_xy px, py
          pad.set_margin
          [pw, ph, px, py]
        end
      end

      attr :verse

      def initialize
        super
      
        initialize_verse
      end

      def initialize_verse
        @verse = new EditableTextVerse, "", wh: 1r, mousy: false, verse_size: 1r
      end

      def sketch
        super

        layout! NoteLayout.new(:b, :c)
        mousy!
        keyboardy!
        out_w! 1
        m! 2
        fill! :gray
        h! 24

        sketch_verse
      end

      def sketch_verse
        text_edition @verse, false
      end

      def sketch_presence
        super

        Event.each(
          on_focus_enter!, 
          on_focus_leave!, 
          on_mouse_enter!, 
          on_mouse_leave!,
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @fill
        kb_top = keyboard_top?
        area.fill = kb_top ? color.darken : mouse_in? ? color.lighten : color
        area.out_fill = kb_top ? :outline_focus : color
        verse.selection.each_paint{ it.fill! kb_top ? :text_selection : :text_selection_inactive }
      end
    end
  end
end