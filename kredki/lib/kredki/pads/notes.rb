require_relative 'text/editable_text_verses'

module Kredki
  module Pads
    # A multiline text control.
    class Notes < Note

      # :section: LEVEL 2

      def sketch
        super

        set_size_y 64
        set_verse_size Kredki.text_size
        set_verse_layout :yss
      end

      def initialize_verse
        @verse = put EditableTextVerses, size: 1r, mousy: false
      end

      def sketch_verse
        text_edition @verse, true
      end

      def mouse_scroll event
        @verse.scroll *Kredki.relative_scroll(*event.xy)
      end

    end
  end
end