require_relative 'text/editable_text_verses'

module Kredki
  module Pads
    # A multiline text control.
    class Notes < Note

      def sketch
        super

        set_size_y 64
        set_verse_size Kredki.text_size
        set_verse_layout :yss
      end

      def sketch_verse
        text_edition @verse, true
      end

      def mouse_scroll event
        @verse.scroll *Kredki.relative_scroll(*event.xy)
      end

      def default_verse
        put EditableTextVerses, size: 1r, mousy: false
      end

    end
  end
end