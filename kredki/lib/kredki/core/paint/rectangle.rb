require_relative 'shape_area'

module Kredki
  class Rectangle < ShapeArea

    # Set X start Y start corner.
    def corner_ss! corner_ss = @corner_ss
      return corner_ss! yield @corner_ss if block_given?
      return if @corner_ss == corner_ss
      @corner_ss = corner_ss
      @redraw_flag = true
      update
    end

    # See #corner_ss!.
    def corner_ss= param
      send_bundle :corner_ss!, param
    end

    # Get X start Y start corner.
    def corner_ss
      @corner_ss
    end

    # Set X start Y end corner.
    def corner_se! corner_se = @corner_se
      return corner_se! yield @corner_se if block_given?
      return if @corner_se == corner_se
      @corner_se = corner_se
      @redraw_flag = true
      update
    end

    # See #corner_se!.
    def corner_se= param
      send_bundle :corner_se!, param
    end

    # Get X start Y end corner.
    def corner_se
      @corner_se
    end

    # Set X end Y start corner.
    def corner_es! corner_es = @corner_es
      return corner_es! yield @corner_es if block_given?
      return if @corner_es == corner_es
      @corner_es = corner_es
      @redraw_flag = true
      update
    end

    # See #corner_es!.
    def corner_es= param
      send_bundle :corner_es!, param
    end

    # Get X end Y start corner.
    def corner_es
      @corner_es
    end

    # Set X end Y end corner.
    def corner_ee! corner_ee = @corner_ee
      return corner_ee! yield @corner_ee if block_given?
      return if @corner_ee == corner_ee
      @corner_ee = corner_ee
      @redraw_flag = true
      update
    end

    # See #corner_ee!.
    def corner_ee= param
      send_bundle :corner_ee!, param
    end

    # Get X end Y end corner.
    def corner_ee
      @corner_ee
    end

    # Set X start corners.
    def corner_xs! corner_ss = @corner_ss, corner_se = corner_ss
      return send_bundle :corner_xs!, yield(self.corner_xs) if block_given?
      return if @corner_ss == corner_ss && @corner_se == corner_se
      @corner_ss = corner_ss
      @corner_se = corner_se
      @redraw_flag = true
      update
    end

    # See #corner_xs!.
    def corner_xs= param
      send_bundle :corner_xs!, param
    end

    # Get X start corners.
    def corner_xs
      [@corner_ss, @corner_se]
    end

    # Set X end corners.
    def corner_xe! corner_es = @corner_es, corner_ee = corner_es
      return send_bundle :corner_xe!, yield(self.corner_xe) if block_given?
      return if @corner_es == corner_es && @corner_ee == corner_ee
      @corner_es = corner_es
      @corner_ee = corner_ee
      @redraw_flag = true
      update
    end

    # See #corner_xe!.
    def corner_xe= param
      send_bundle :corner_xe!, param
    end

    # Get X end corners.
    def corner_xe
      [@corner_es, @corner_ee]
    end


    # Set Y start corners.
    def corner_ys! corner_ss = @corner_ss, corner_es = corner_ss
      return send_bundle :corner_ys!, yield(self.corner_ys) if block_given?
      return if @corner_ss == corner_ss && @corner_es == corner_es
      @corner_ss = corner_ss
      @corner_es = corner_es
      @redraw_flag = true
      update
    end
    
    # See #corner_ys!.
    def corner_ys= param
      send_bundle :corner_ys!, param
    end

    # Get Y start corners.
    def corner_ys
      [@corner_ss, @corner_es]
    end

    # Set Y end corners.
    def corner_ye! corner_se = @corner_se, corner_ee = corner_se
      return send_bundle :corner_ye!, yield(self.corner_ye) if block_given?
      return if @corner_se == corner_se && @corner_ee == corner_ee
      @corner_se = corner_se
      @corner_ee = corner_ee
      @redraw_flag = true
      update
    end
    
    # See #corner_ye!.
    def corner_ye= param
      send_bundle :corner_ye!, param
    end

    # Get Y end corners.
    def corner_ye
      [@corner_se, @corner_ee]
    end
    
    # Set corners.
    def corner! corner_ss = @corner_ss, corner_es = corner_ss, corner_se = corner_ss, corner_ee = corner_es
      return send_bundle :corner!, yield(self.corner) if block_given?
      return if @corner_ss == corner_ss && @corner_es == corner_es && @corner_se == corner_se && @corner_ee == corner_ee
      @corner_ss = corner_ss
      @corner_es = corner_es
      @corner_se = corner_se
      @corner_ee = corner_ee
      @redraw_flag = true
      update
    end

    # See #corner!.
    def corner= param
      send_bundle :corner!, param
    end
    
    # Get corners.
    def corner
      [@corner_ss, @corner_es, @corner_se, @corner_ee]
    end

    # :section: LEVEL 2

    def initialize
      @corner_ss = @corner_se = @corner_es = @corner_ee = 0
      super
      update
    end

    def redraw
      draw!(true, @size_x * 0.5 , @size_y * 0.5).rectangle! @size_x - @outline_w, @size_y - @outline_w, @corner_ss, @corner_es, @corner_se, @corner_ee
    end

    def set_outline_w ...
      super
      @redraw_flag = true
    end
  end
end