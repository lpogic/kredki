require_relative 'text_navigation'

module Kredki
  module UI
    module TextEdition
      include TextNavigation
      
      def on_edit! &block
        on! EditEvent, &block
      end

      def text_edition text, multiline
        text_navigation text

        on_key_down! :backspace do |e|
          text.backspace
          e.resolve
        end

        on_key_down! :delete do |e|
          text.delete
          e.resolve
        end

        on_text! do |e|
          text.paste e.param
          e.resolve
        end

        on_key_down! :v do |e|
          if e.ctrl?
            text.paste clipboard.content
            e.resolve
          end
        end

        on_key_down! :x do |e|
          if e.ctrl? && (text.selection? || e.shift?)
            s = e.shift? ? clipboard.content : ""
            clipboard.content = text.selected_content if text.selection?
            text.paste s
            e.resolve
          end
        end

        on_edit! do |e|
          text.edit e.action, e.string, e.selection_min, e.selection_max
        end

        if multiline
          on_key_down! :enter do |e|
            text.paste "\n"
            e.resolve
          end
        end
      end

    end
  end
end