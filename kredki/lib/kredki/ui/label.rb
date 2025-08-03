require_relative 'text/navigable_text'

module Kredki
  module UI
    class Label < SortPad
      include TextNavigation
      extend HasParams
      
      #internal api

      def initialize
        super

        @text = new NavigableText, h: 100r do
          # cursor.w = 0
        end
      end

      param def for! for_
        return if @for == for_
        @for = for_
        true
      end

      param def text! text
        @text.content! text
      end, def text
        @text.content
      end

      def << arg
        case arg
        when String
          text! arg
        else
          super
        end
      end

      def sketch p0
        super

        wh! :fit, 24
        for! :~
        keyboardy!

        text_navigation @text

        # on_mouse_click! do |e|
        #   find_pad @for, proc{ it.keyboardy? } do
        #     focus!
        #     report e
        #   end
        # end
      end
    end
  end
end