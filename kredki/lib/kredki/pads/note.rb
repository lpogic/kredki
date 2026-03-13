require_relative 'text/editable_text_verse'

module Kredki
  module Pads
    # Control with text entry.
    class Note < RectanglePad
      include TextEdition

      # Set text content.
      def text! text = ""
        return send_bundle :text!, yield(self.text) if block_given?
        @verse.subject! text
      end

      # See #text!.
      def text= param
        send_bundle :text!, param
      end
      
      # Get text content.
      def text
        @verse.text
      end

      # Set suit.
      def suit! *suit
        return send_bundle :suit!, yield(self.suit) if block_given?
        suit = Util.uncover suit
        return if @suit == suit && suit != :random
        @suit = suit
        repaint
        true
      end

      # See #suit!.
      def suit= param
        send_bundle :suit!, param
      end

      # Get suit.
      def suit
        @suit
      end

      # Set verse features.
      def verse! ...
        send_branch(:verse, ...)
      end

      # See #verse!.
      def verse= param
        send_bundle :verse!, param
      end
      
      # Set verse size.
      def verse_size! ...
        @verse.verse_size!(...)
      end

      # See #verse_size!.
      def verse_size= param
        send_bundle :verse_size!, param
      end

      # Get verse size.
      def verse_size
        @verse.verse_size
      end

      # Set verse font.
      def verse_font! ...
        @verse.font!(...)
      end

      # See #verse_font!.
      def verse_font= param
        send_bundle :verse_font!, param
      end

      # Get verse font.
      def verse_font
        @verse.font
      end

      # Set verse layout.
      def verse_layout! ...
        @verse.verse_layout!(...)
      end

      # See #verse_layout!.
      def verse_layout= param
        send_bundle :verse_layout!, param
      end

      # Get verse layout.
      def verse_layout
        @verse.verse_layout
      end

      # Push the feature.
      def << feature
        case feature
        when String
          text! feature
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
          pad.set_xy px, py
          pad.set_margin
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

        layout! NoteLayout.new(Start, Center)
        mousy!
        keyboardy!
        outline_w! 1
        margin! 2
        suit! :gray
        size_y! Fit

        sketch_verse
      end

      def sketch_verse
        text_edition @verse, false
      end

      def behavior
        super

        on_mouse_scroll do: method(:mouse_scroll)

        on_mouse_press :scroll do |e|
          drag! e.xy, :scroll
          e.close
        end

        on_mouse_move do |e|
          if e.drag? && e.button == :scroll
            @verse.process_drag e
            e.close
          end
        end

        on_edit early: true do |e|
          e.close if disabled?
        end
      end

      def mouse_scroll event
        x, y = window.relative_scroll(*event.xy)
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

        if disabled?
          opacity! 3/4r
          mouse_cursor! nil
          area.fill! color
          area.outline_fill! color
        else
          opacity! 1r
          mouse_cursor! :text
          area.fill! kb_top ? color.darken : mouse_in? ? color.lighten : color
          area.outline_fill! kb_top ? :outline_focus : color
        end
        verse.selection.each_paint{|it| it.fill! kb_top ? :text_selection : :text_selection_inactive }
      end
    end
  end
end