module Kredki
  module Area

    feature :size_x # Size in X axis.

    def set_size_x size_x
      return if @size_x == size_x
      @size_x = size_x
      @redraw_flag = true
      update
    end
    
    def size_x
      @size_x
    end

    feature :size_y # Size in Y axis.

    def set_size_y size_y
      return if @size_y == size_y
      @size_y = size_y
      @redraw_flag = true
      update
    end
    
    def size_y
      @size_y
    end

    feature :size
    
    def set_size size_x, size_y = size_x
      return if @size_x == size_x && @size_y == size_y
      @size_x = size_x
      @size_y = size_y
      @redraw_flag = true
      update
    end
    
    def size
      [@size_x, @size_y]
    end

    # Check wheather [+x+, +y+] is inside the Area.
    def include_point x, y
      x <= @size_x && y <= @size_y && x >= 0 && y >= 0
    end
  end
end