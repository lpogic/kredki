require_relative 'label'

module Kredki
  module UI
    class Edit < Label

      def sketch p0
        super

        on_key! :backspace do |e|
          backspace
          e.resolve
        end

        on_key! :delete do |e|
          delete
          e.resolve
        end

        on_text! do |e|
          paste e[]
          e.resolve
        end

        on_key! :v do |e|
          paste clipboard.string
          e.resolve
        end

        on_edit! do |e|
          s! string.then{|s| s == "" ? e.string : s[...e.selection_min] + e.string + s[e.selection_max..]}, false
          reset_cursor e.selection_min + e.string.length
          e.resolve
        end
      end

      def on_edit! &block
        on! EditEvent, &block
      end

      def paste pasted
        report EditEvent.new @selection_min, @selection_max, pasted, :paste
      end

      def backspace
        if selection?
          report EditEvent.new @selection_min, @selection_max, "", :backspace
        elsif @cursor_position > 0
          report EditEvent.new @cursor_position - 1, @cursor_position, "", :backspace
        end
      end

      def delete
        if selection?
          report EditEvent.new @selection_min, @selection_max, "", :backspace
        elsif @cursor_position < string.length
          report EditEvent.new @cursor_position, @cursor_position + 1, "", :backspace
        end
      end
    end
  end
end