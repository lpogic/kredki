require_relative 'text/editable_text_verses'

module Kredki
  module UI
    class Notes < Note

      #internal api

      def sketch
        super

        h! 74
        verse_size! 24
        verse_layout! :ybb
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