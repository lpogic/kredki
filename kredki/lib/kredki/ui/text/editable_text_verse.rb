require_relative 'text_edition'

module Kredki
  module UI
    class EditableTextVerse < NavigableText
      include TextEdition

      def content! content = @content, reset_cursor = false, &b
        super("#{content}\n".each_line(chomp: true).to_a.join, reset_cursor, &b)
      end
    end
  end
end