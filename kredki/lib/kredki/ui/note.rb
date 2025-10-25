require_relative 'text/editable_text_verse'

module Kredki
  module UI
    class Note < ShapePad
      include TextEdition
      extend Forwardable
      extend HasParams

      param def color! *color
        return color! *Util.cover(yield self.color) if block_given?
        color = Util.uncover color
        return if @color == color
        @color = color
        repaint
        true
      end

      def theme
        Event.each(
          on_focus_enter!, 
          on_focus_leave!, 
          on_mouse_enter!, 
          on_mouse_leave!,
        ) do
          repaint
        end
      end

      def repaint
        color = Kredki.color @color
        kb_top = keyboard_top?
        area.fill_color = kb_top ? color.darken : mouse_in? ? color.lighten : color
        area.stroke_color = kb_top ? :stroke_focus : color
        verse.selection.each_paint{ it.fill_color! kb_top ? :text_selection : :text_selection_inactive }
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

      param_prefix :verse

      param_delegate :@verse,
        :verse_size,
        :verse_layout

      #internal api

      class NoteLayout < Layout::XWay
        def arrange_layoutic pad, cw, ch, cx
          pw = pad.sw
          ph = pad.sh
          px = pad.get_x cw, pw, cx
          py = pad.get_y ch, ph, (get_y @y, ch, ph)
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
        @theme = nil
      end

      def initialize_verse
        @verse = new EditableTextVerse, "", wh: 1r, mousy: false
      end

      def sketch p0
        super

        layout! NoteLayout.new(:b, :c)
        mousy!
        keyboardy!
        stroke_size! 1
        m! 1
        color! :gray
        h! 24

        sketch_verse
        theme
      end

      def sketch_verse
        text_edition @verse, false
      end
    end
  end
end