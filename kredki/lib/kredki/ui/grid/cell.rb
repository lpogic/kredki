module Kredki
  module UI
    class GridPad
      class Cell < Pad
        model :col, :row, :colspan, :rowspan do |sup|
          sup.call
          @colspan ||= 1
          @rowspan ||= 1
        end

        def sketch p0
          super

          area.hide!

          on_resize! do |e|
            if e.target != self
              e.resolve
              parent.update_pads
            end
          end
        end

        def << arg
          case arg
          when Integer
            if !@col
              @col = arg
            elsif !@row
              @row = arg
            elsif !@colspan
              @colspan = arg
            elsif !@rowspan
              @rowspan = arg
            end
          else
            super
          end
        end

        def min_col
          @col
        end

        def min_row
          @row
        end

        def max_col
          @col + @colspan - 1
        end

        def max_row
          @row + @rowspan - 1
        end

        def max_x
          pads.map{ _1.max_x }.max || 0
        end

        def max_y
          pads.map{ _1.max_y }.max || 0
        end

        def remove_pad ...
          removed = super
          if pads.empty?
            parent.remove_pad self, false
          end
          removed
        end
      end
    end
  end
end