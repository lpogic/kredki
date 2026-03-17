module Kredki
  module Area

    # Set size in X axis.
    def set_size_x size_x = @size_x
      return set_size_x yield @size_x if block_given?
      return if @size_x == size_x
      @size_x = size_x
      @redraw_flag = true
      update
    end

    # See #set_size_x.
    def size_x= param
      send_bundle :set_size_x, param
    end

    # Get size in X axis.
    def size_x
      @size_x
    end

    # Set size in Y axis.
    def set_size_y size_y = @size_y
      return set_size_y yield @size_y if block_given?
      return if @size_y == size_y
      @size_y = size_y
      @redraw_flag = true
      update
    end

    # See #set_size_y.
    def size_y= param
      send_bundle :set_size_y, param
    end

    # Get size in Y axis.
    def size_y
      @size_y
    end

    # Set size.
    def set_size size_x = @size_x, size_y = size_x
      return send_bundle :set_size, yield(self.size) if block_given?
      return if @size_x == size_x && @size_y == size_y
      @size_x = size_x
      @size_y = size_y
      @redraw_flag = true
      update
    end

    # See #set_size.
    def size= param
      send_bundle :set_size, param
    end
    
    # Get size.
    def size
      [@size_x, @size_y]
    end

    # Check wheather [+x+, +y+] is inside the Area.
    def contain? x, y
      x <= @size_x && y <= @size_y && x >= 0 && y >= 0
    end
  end
end