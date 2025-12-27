require_relative 'text/editable_text_verses'

module Kredki
  module UI
    # A multiline text control.
    class Notes < Note

      # :section: LEVEL 2

      def sketch
        super

        h! 64
        verse_size! 20
        verse_layout! :yss
      end

      def initialize_verse
        @verse = new EditableTextVerses, wh: 1r
      end

      def sketch_verse
        text_edition @verse, true
      end

    end
  end
end