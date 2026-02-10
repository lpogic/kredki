require_relative 'text/editable_text_verses'

module Kredki
  module Pads
    # A multiline text control.
    class Notes < Note

      # :section: LEVEL 2

      def sketch
        super

        h! 64
        verse_size! Kredki.text_size
        verse_layout! :yss
      end

      def initialize_verse
        @verse = new EditableTextVerses, wh: 1r
      end

      def sketch_verse
        text_edition @verse, true
      end

      def mouse_scroll event
        @verse.scroll *window.relative_scroll(*event.xy)
      end

    end
  end
end