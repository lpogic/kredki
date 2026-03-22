require_relative 'text/editable_text_verse'

module Kredki
  module Pads
    # Control with text entry.
    class Note < RectanglePad
      include TextEdition

      # Set text content.
      def set_text text = ""
        return send_bundle :set_text, yield(self.text) if block_given?
        @verse.set_subject text
      end

      # See #set_text.
      def text= param
        send_bundle :set_text, param
      end
      
      # Get text content.
      def text
        @verse.text
      end

      # Set suit.
      def set_suit *suit
        return send_bundle :set_suit, yield(self.suit) if block_given?
        suit = Util.uncover suit
        return if @suit == suit && suit != :random
        @suit = suit
        repaint
        true
      end

      # See #set_suit.
      def suit= param
        send_bundle :set_suit, param
      end

      # Get suit.
      def suit
        @suit
      end

      # Set verse features.
      def set_verse ...
        send_branch(__method__, ...)
      end

      # See #set_verse.
      def verse= param
        send_bundle :set_verse, param
      end
      
      # Set verse size.
      def set_verse_size ...
        @verse.set_verse_size(...)
      end

      # See #set_verse_size.
      def verse_size= param
        send_bundle :set_verse_size, param
      end

      # Get verse size.
      def verse_size
        @verse.verse_size
      end

      # Set verse font.
      def set_verse_font ...
        @verse.set_font(...)
      end

      # See #set_verse_font.
      def verse_font= param
        send_bundle :set_verse_font, param
      end

      # Get verse font.
      def verse_font
        @verse.font
      end

      # Set verse layout.
      def set_verse_layout ...
        @verse.set_verse_layout(...)
      end

      # See #set_verse_layout.
      def verse_layout= param
        send_bundle :set_verse_layout, param
      end

      # Get verse layout.
      def verse_layout
        @verse.verse_layout
      end

      # Set a feature recognized by its class.
      def << feature
        case feature
        when String
          set_text feature
        else
          super
        end
      end

      # :section: LEVEL 2

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
      
        @verse = nil
      end

      attr :verse

      def initialize_verse
        @verse = put EditableTextVerse, "", size_x: 1r, mousy: false, verse_size: Kredki.text_size
      end

      def sketch
        super

        initialize_verse

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
        kb_top = keyboard_top?

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
        verse.selection.each_paint{|it| it.set_fill kb_top ? :text_selection : :text_selection_inactive }
      end
    end
  end
end