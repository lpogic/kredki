require_relative 'text/editable_text_verses'

module Kredki
  module UI
    class Notes < Note

      #internal api

      def initialize_verse
        @verse = new EditableTextVerses, wh: 100r
      end

      def sketch_verse
        text_edition @verse, true
      end
    end
  end
end