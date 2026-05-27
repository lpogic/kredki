module Kredki
  module Pads
    module Layout
      # A layout in which elements are positioned one next to another.
      class Way
        include Layout

        # :section: LEVEL 2

        PadSizeCharacteristic = Struct.new :pad, :span, :min, :max, :size

        def determine_size_characteristics size_characteristics, lower_size, spacer
          return 0 if size_characteristics.empty?
          value = 0
          min = 0
          span_sum = 0
          size_characteristics.each do |characteristic|
            min += characteristic.min if characteristic.span == 0
            value += characteristic.min
            span_sum += characteristic.span
          end
          total_space = spacer * (size_characteristics.size - 1)
          min += total_space

          left_size = lower_size - min
          if span_sum > 0 && left_size > 0
            distributed_size_unit = left_size / span_sum
            left_size = 0
            size_characteristics.each do |it|
              if it.span > 0
                distributed_size = distributed_size_unit * it.span
                if distributed_size > it.max
                  it.size = it.max
                  left_size += distributed_size - it.max
                elsif distributed_size < it.min
                  it.size = it.min
                  left_size += distributed_size - it.min
                else
                  distributed_size_floor = distributed_size.floor
                  it.size = distributed_size_floor
                  left_size += distributed_size - distributed_size_floor
                end
              end
            end

            loop do
              min_span_characteristic = nil
              span_sum = 0 
              if left_size > 0
                size_characteristics.each do |it| 
                  if it.size < it.max
                    span_sum += it.span
                    min_span_characteristic = it if it.span > 0 && (!min_span_characteristic || min_span_characteristic.span > it.span)
                  end
                end
                break if span_sum == 0
                distributed_size_unit = left_size / span_sum
                new_left_size = 0
                size_characteristics.each do |it|
                  if it.size < it.max && it.span > 0
                    distributed_size = distributed_size_unit * it.span + it.size
                    if distributed_size > it.max
                      it.size = it.max
                      new_left_size += distributed_size - it.max
                    else
                      distributed_size_floor = distributed_size.floor
                      it.size = distributed_size_floor
                      new_left_size += distributed_size - distributed_size_floor
                    end
                  end
                end
                min_span_characteristic.span = 0 if left_size == new_left_size
                left_size = new_left_size
              elsif left_size < 0
                size_characteristics.each do |it| 
                  if it.size > it.min
                    span_sum += it.span
                    min_span_characteristic = it if it.span > 0 && (!min_span_characteristic || min_span_characteristic.span > it.span)
                  end
                end
                break if span_sum == 0
                distributed_size_unit = left_size / span_sum
                new_left_size = 0
                size_characteristics.each do |it|
                  if it.size > it.min
                    distributed_size = distributed_size_unit * it.span + it.size
                    if distributed_size < it.min
                      it.size = it.min
                      new_left_size += distributed_size - it.min
                    else
                      distributed_size_floor = distributed_size.floor
                      it.size = distributed_size_floor
                      new_left_size += distributed_size - distributed_size_floor
                    end
                  end
                end
                min_span_characteristic.span = 0 if left_size == new_left_size
                left_size = new_left_size
              else
                break
              end
            end
            
            return size_characteristics.map{|it| it.size }.sum + total_space
          end
          value + total_space
        end

        def arrange_non_layoutic pad, csx, csy
          sx = pad.get_size_x csx
          sy = pad.get_size_y csy
          pad.update_size sx, sy
          x = pad.get_x csx, sx, (get_x @x, csx, sx)
          y = pad.get_y csy, sy, (get_y @y, csy, sy)
          pad.update_xy x, y
          pad.update_margin
          pad.arrange
        end
        
      end#Way
    end#Layout
  end#Pads
end#Kredki