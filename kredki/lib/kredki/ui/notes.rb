require_relative 'text/editable_text_verses'

module Kredki
  module UI
    class Notes < Note

      #internal api

      def initialize_text
        @text = new EditableTextVerses, wh: 100r
      end
    end
  end
end