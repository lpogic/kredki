module Kredki
  module Pads
    # Default text history model.
    class TextHistory

      class Entry
        def initialize selection_start, old_part, new_part, action
          super()
          @selection_start = selection_start
          @old_part = old_part
          @new_part = new_part
          @action = action
        end

        attr_accessor :selection_start
        attr_accessor :old_part
        attr_accessor :new_part
        attr_accessor :action
      end

      def initialize
        @past = []
        @futher = []
        @current = nil
      end

      def step_backward text
        push_past
        current = @past.pop
        if current
          selection_end = current.selection_start + current.new_part.length
          text.report_edit_event current.selection_start, selection_end, current.old_part, :history_backward
        end
      end

      def step_forward text
        current = @futher.pop
        if current && !@current
          selection_end = current.selection_start + current.new_part.length
          text.report_edit_event current.selection_start, selection_end, current.old_part, :history_forward
        end
      end

      def push_event event
        if event.action == :history_backward
          @futher << Entry.new(event.selection_start, event.old_part, event.new_part, event.action)
          return
        end
        if event.action == :history_forward
          @past << Entry.new(event.selection_start, event.old_part, event.new_part, event.action)
          return
        else
          @futher = []
        end
        if @current
          case @current.action
          when :text_input
            if event.action == :text_input &&
              event.selection_start == event.selection_end &&
              event.selection_start == @current.selection_start + @current.new_part.length
            then
              if event.new_part == " "
                if @current.new_part.end_with? " "
                  @current.new_part += event.new_part
                  return
                end
              else
                if !@current.new_part.end_with?(" ") || @current.new_part == " "
                  @current.new_part += event.new_part
                  return
                end
              end
            end
          when :backspace
            if event.action == @current.action && event.selection_end == @current.selection_start
              @current.selection_start = event.selection_start
              @current.old_part = event.old_part + @current.old_part
              return
            end
          when :delete
            if event.action == @current.action && event.selection_start == @current.selection_start
              @current.old_part += event.old_part
              return
            end
          end
        end
        push_past event
      end

      def push_past event = nil
        @past << @current if @current
        if event
          @current = Entry.new event.selection_start, event.old_part, event.new_part, event.action
        else
          @current = nil
        end
      end
    end
  end
end