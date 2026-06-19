module Kredki
  module Pads
    module Table
      # Column layout.
      class ColumnLayout < Layout::XWay
        
        # Add new column.
        def column! ...
          @columns << Column.new.set(...)
        end

        feature :spacer # Spacer between columns.

        # :section: LEVEL 2
        
        def initialize table, x, y
          super(x, y)
          @table = table
          @columns = []
          @measure_phase = true
          @pad_size_characteristics = nil
        end
  
        def arrange pad
          @measure_phase ? measure_arrange(pad) : proper_arrange(pad)
        end

        def measure_arrange pad
          csx = @table.clip_size_x

          @pad_size_characteristics = pad.layoutic_pads.zip(@columns, @pad_size_characteristics).map do |p1, column, last_characteristic|
            new_characteristic = get_size_characteristic p1, column&.size || Auto, column&.limit, csx

            if last_characteristic
              min = [new_characteristic.min, last_characteristic.min].max
              max = [new_characteristic.max, last_characteristic.max].min
              PadSizeCharacteristic.new p1, new_characteristic.span, min, max, min
            else
              new_characteristic
            end
          end
        end

        def proper_arrange pad
          client_size_y = pad.clip_size_y
          client_size_x = @table.clip_size_x
          size_x = @size_x

          pad.layoutic_pads.zip @pad_size_characteristics do |p1, characteristic|
            if characteristic
              sx = characteristic.size
            else
              sx = client_size_x - size_x
              size_x = client_size_x
            end
            sy = p1.get_size_y client_size_y
            p1.update_size sx, sy
          end
          arrange_pads pad.arranged_pads, size_x, client_size_x, client_size_y, @spacer || 0
        end
  
        def prepare
          @measure_phase = true
          @pad_size_characteristics = []
        end
  
        def designate
          @size_x = determine_size_characteristics @pad_size_characteristics, @table.clip_size_x, @spacer || 0
          @measure_phase = false
        end
  
        def release
          @pad_size_characteristics = nil
        end
        
      end
    end
  end
end