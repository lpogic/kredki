require_relative 'text_edition'

module Kredki
  module UI
    class EditableTextVerses < NavigableText
      include TextEdition

      #internal api

      def sketch p0
        super

        on_key! :enter do |e|
          paste "\n"
          e.resolve
        end
      end
    end
  end
end