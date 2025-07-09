require_relative 'text/navigable_text'

module Kredki
  module UI
    class Label < NavigableText
      
      #internal api

      param def for! f
        return if @for == f
        @for = f
        true
      end

      def sketch p0
        super

        cursor.color = false
        keyboardy!
        for! :+

        on_click! do |e|
          self[@for, proc{ it.keyboardy? }] do
            focus!
            report e
          end
        end
      end
    end
  end
end