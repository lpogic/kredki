require_relative 'text/editable_text_verse'

module Kredki
  module Pads
    # Control with text entry.
    class Note < RectanglePad
      include TextEdition

      # Set text content.
      def content! string = ""
        return send_ahp :content!, yield(self.content) if block_given?
        @verse.content! string
      end

      # See #content!.
      def content= param
        send_ahp :content!, param
      end
      
      # Get text content.
      def content
        @verse.content
      end

      # Set suit.
      def suit! *suit
        return send_ahp :suit!, yield(self.suit) if block_given?
        suit = Util.uncover suit
        return if @suit == suit && suit != :rand
        @suit = suit
        repaint
        true
      end

      # See #suit!.
      def suit= param
        send_ahp :suit!, param
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
        send_ahp :verse!, param
      end
      
      # Set verse size.
      def verse_size! ...
        @verse.verse_size!(...)
      end

      # See #verse_size!.
      def verse_size= param
        send_ahp :verse_size!, param
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
        send_ahp :verse_font!, param
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
        send_ahp :verse_layout!, param
      end

      # Get verse layout.
      def verse_layout
        @verse.verse_layout
      end

      # Push the feature.
      def << feature
        case feature
        when String
          content! feature
        else
          super
        end
      end

      # Convert to string.
      def to_s
        content
      end

      # :section: LEVEL 2

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

      def initialize
        super
      
        @verse = nil
      end

      attr :verse

      def initialize_verse
        @verse = new EditableTextVerse, "", w: 1r, mousy: false, verse_size: 20
      end

      def sketch
        super

        initialize_verse

        layout! NoteLayout.new(:start, :center)
        mousy!
        keyboardy!
        outline_w! 1
        m! 2
        suit! :gray
        h! :fit

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