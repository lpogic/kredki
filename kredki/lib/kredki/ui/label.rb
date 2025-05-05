require_relative 'text/text_line'

module Kredki
  module UI
    class Label < TextLine
      
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
        for! :-

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