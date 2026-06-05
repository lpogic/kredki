require_relative 'text/editable_text_verse'

module Kredki
  module Pads
    # Control with text entry.
    class Note < RectanglePad
      include TextEdition

      def mixed_set feature
        case feature
        when String
          set_text feature
        else
          super
        end
      end

      feature :suit # Basic appearance.

      def set_suit *suit
        suit = Util.uncover suit
        return if @suit == suit && suit != :random
        @suit = suit
        repaint
        true
      end

      def suit
        @suit
      end

      feature :text # Text content.

      def set_text text = ""
        @verse.set_subject text
      end

      def text
        @verse.text
      end

      feature :verse # Nest of verse features.

      def set_verse *a, **ka
        a.count do |it| 
          case it
          when Numeric
            set_verse_size it
          when :yss, :ysc, :yse, :yes, :yec, :yee, :ycs, :ycc, :yce
            set_verse_layout it
          else
            set_verse_font it
          end
        end.zero?.not | nest_set(__method__, ka)
      end

      feature :verse_font # Font family.

      def set_verse_font ...
        @verse.set_font(...)
      end

      def verse_font
        @verse.font
      end

      feature :verse_layout # Text alignment.

      def set_verse_layout ...
        @verse.set_verse_layout(...)
      end

      def verse_layout
        @verse.verse_layout
      end

      feature :verse_size # Font size.

      def set_verse_size ...
        @verse.set_verse_size(...)
      end

      def verse_size
        @verse.verse_size
      end

      
      class NoteLayout < Layout::XWay
        def arrange_layoutic pad, clip_size_x, clip_size_y, cx
          sx, sy = pad.area_size
          px = pad.get_x clip_size_x, sx, cx
          py = pad.get_y clip_size_y, sy, (get_y @y, clip_size_y, sy)
          pad.arrange
          pad.update_xy px, py
          pad.update_margin
          [sx, sy, px, py]
        end
      end

      def initialize
        super
      
        @verse = default_verse
      end

      attr :verse

      def sketch
        super

        set_layout NoteLayout.new(Start, Center)
        set_mousy
        set_keyboardy
        set_stroke_width 1
        set_margin 2
        set_suit :gray
        set_size_y Fit

        sketch_verse
      end

      def sketch_verse
        text_edition @verse, false
      end

      def presence
        super

        Event.each(
          on_focus_enter, 
          on_focus_leave, 
          on_mouse_enter, 
          on_mouse_leave,
          do: method(:repaint)
        )
      end

      def repaint event = nil
        color = Kredki.color @suit
        kb_top = keyboard_top

        if in_disabled
          set_opacity 3/4r
          set_mouse_cursor nil
          area.set_fill color
          area.set_stroke_fill color
        else
          set_opacity 1r
          set_mouse_cursor :text
          area.set_fill kb_top ? color.darken : mouse_in ? color.lighten : color
          area.set_stroke_fill kb_top ? :stroke_focus : color
        end
        verse.selection.paints.each{|it| it.set_fill kb_top ? :text_selection : :text_selection_inactive }
      end

      def behavior
        super

        on_mouse_scroll do: method(:mouse_scroll)

        on_mouse_press :scroll do |e|
          start_drag e.xy, :scroll
          e.close
        end

        on_mouse_move do |e|
          if e.drag? && e.button == :scroll
            @verse.process_drag e
            e.close
          end
        end

        on_edit early: true do |e|
          e.close if in_disabled
        end
      end

      def mouse_scroll event
        x, y = Kredki.relative_scroll(*event.xy)
        @verse.scroll x == 0 ? y : x, y
      end

      def default_verse
        put EditableTextVerse, "", size_x: 1r, mousy: false, verse_size: Kredki.text_size
      end
    end
  end
end