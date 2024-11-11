require_relative 'text/text_line'
require_relative 'text/text_column'

module Kredki
  module UI
    module Editor

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
          if e.ctrl?
            paste clipboard.string
            e.resolve
          end
        end

        on_key! :x do |e|
          if e.ctrl? && (selection? || e.shift?)
            s = e.shift? ? clipboard.string : ""
            clipboard.string = string[@selection_min...@selection_max] if selection?
            paste s
            e.resolve
          end
        end

        on_edit! do |e|
          edit e.string, e.selection_min, e.selection_max
        end
      end

      def edit string, selection_min, selection_max
        s = self.string
        s = if s == ""
          string
        elsif selection_max < s.length
          s[...selection_min] + string + s[selection_max..]
        else
          s[...selection_min] + string
        end
        s! s, false
        reset_cursor selection_min + string.length
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
        elsif string.length > 0
          backspace
        end
      end
    end

    class TextLineEditor < TextLine
      include Editor
    end

    class TextColumnEditor < TextColumn
      include Editor

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