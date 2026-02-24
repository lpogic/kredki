module Kredki
  module Area

    # Set width.
    def w! w = @w
      return w! yield @w if block_given?
      return if @w == w
      @w = w
      @redraw_flag = true
      update
    end

    # See #w!.
    def w= param
      send_bundle :w!, param
    end

    # Get width.
    def w
      @w
    end

    # Set height.
    def h! h = @h
      return h! yield @h if block_given?
      return if @h == h
      @h = h
      @redraw_flag = true
      update
    end

    # See #h!.
    def h= param
      send_bundle :h!, param
    end

    # Get height.
    def h
      @h
    end

    # Set width and height.
    def wh! w = @w, h = w
      return send_bundle :wh!, yield(self.wh) if block_given?
      return if @w == w && @h == h
      @w = w
      @h = h
      @redraw_flag = true
      update
    end

    # See #wh!.
    def wh= param
      send_bundle :wh!, param
    end
    
    # Get width and height.
    def wh
      [@w, @h]
    end

    # Check wheather [+x+, +y+] is inside the Area.
    def contain? x, y
      x <= @w && y <= @h && x >= 0 && y >= 0
    end
  end
end