require_relative 'shape_area'

module Kredki
  class Rectangle < ShapeArea

    feature :corner_ss # X start Y start corner.

    def set_corner_ss corner_ss
      return if @corner_ss == corner_ss
      @corner_ss = corner_ss
      @redraw_flag = true
      update
    end
    
    def corner_ss
      @corner_ss
    end

    feature :corner_se # X start Y end corner.
    
    def set_corner_se corner_se
      return if @corner_se == corner_se
      @corner_se = corner_se
      @redraw_flag = true
      update
    end

    def corner_se
      @corner_se
    end

    feature :corner_es # X end Y start corner.
    
    def set_corner_es corner_es
      return if @corner_es == corner_es
      @corner_es = corner_es
      @redraw_flag = true
      update
    end
    
    def corner_es
      @corner_es
    end

    feature :corner_ee # X end Y end corner.

    def set_corner_ee corner_ee
      return if @corner_ee == corner_ee
      @corner_ee = corner_ee
      @redraw_flag = true
      update
    end
    
    def corner_ee
      @corner_ee
    end

    feature :corner_xs # X start corners.
    
    def set_corner_xs corner_ss, corner_se = corner_ss
      return if @corner_ss == corner_ss && @corner_se == corner_se
      @corner_ss = corner_ss
      @corner_se = corner_se
      @redraw_flag = true
      update
    end
    
    def corner_xs
      [@corner_ss, @corner_se]
    end

    feature :corner_xe # X end corners.
    
    def set_corner_xe corner_es, corner_ee = corner_es
      return if @corner_es == corner_es && @corner_ee == corner_ee
      @corner_es = corner_es
      @corner_ee = corner_ee
      @redraw_flag = true
      update
    end
    
    def corner_xe
      [@corner_es, @corner_ee]
    end

    feature :corner_ys # Y start corners.

    def set_corner_ys corner_ss, corner_es = corner_ss
      return if @corner_ss == corner_ss && @corner_es == corner_es
      @corner_ss = corner_ss
      @corner_es = corner_es
      @redraw_flag = true
      update
    end
    
    def corner_ys
      [@corner_ss, @corner_es]
    end

    feature :corner_ye # Y end corners.
    
    def set_corner_ye corner_se, corner_ee = corner_se
      return if @corner_se == corner_se && @corner_ee == corner_ee
      @corner_se = corner_se
      @corner_ee = corner_ee
      @redraw_flag = true
      update
    end
    
    def corner_ye
      [@corner_se, @corner_ee]
    end
    
    feature :corner
    
    def set_corner corner_ss = @corner_ss, corner_es = corner_ss, corner_se = corner_ss, corner_ee = corner_es, **ka
      unless @corner_ss == corner_ss && @corner_es == corner_es && @corner_se == corner_se && @corner_ee == corner_ee
        @corner_ss = corner_ss
        @corner_es = corner_es
        @corner_se = corner_se
        @corner_ee = corner_ee
        @redraw_flag = true
        update
      end | nest_set(__method__, ka)
    end
    
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
      draw(true, @size_x * 0.5 , @size_y * 0.5).rectangle @size_x - @stroke_width, @size_y - @stroke_width, @corner_ss, @corner_es, @corner_se, @corner_ee
    end

    def update_stroke_width ...
      super
      @redraw_flag = true
    end
  end
end