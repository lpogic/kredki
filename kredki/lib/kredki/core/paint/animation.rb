module Kredki
  # Picture that may change over time.
  class Animation

    def mixed_set feature
      case feature
      in [x, y]
        set_size x, y
      in Numeric
        set_size feature
      in String
        set_content feature
      else
        super
      end
    end

    feature :content
    
    def set_content ...
      if @picture.set_content(...)
        @duration = (Pastele.animation_get_duration(@pointer) * 1000).to_i
        @total_frames = Pastele.animation_get_total_frames @pointer
        @frame = 0
        true
      end
    end
    
    def content
      @content
    end

    feature :size_x # Size in X axis.

    def set_size_x ...
      @picture.set_size_x(...)
    end
    
    def size_x
      @picture.size_x
    end

    feature :size_y # Size in Y axis.

    def set_size_y ...
      @picture.set_size_y(...)
    end
    
    def size_y
      @picture.size_y
    end

    feature :size
    
    def set_size ...
      @picture.set_size(...)
    end
    
    def size
      @picture.size
    end

    feature :turn
    
    def set_turn ...
      @picture.set_turn(...)
    end
    
    def turn
      @picture.turn
    end

    feature :zoom_x # Zoom in the X axis.

    def set_zoom_x ...
      @picture.set_zoom_x(...)
    end
    
    def zoom_x
      @picture.zoom_x
    end

    feature :zoom_y # Zoom in the Y axis.

    def set_zoom_y ...
      @picture.set_zoom_y(...)
    end
    
    def zoom_y
      @picture.zoom_y
    end

    feature :zoom
    
    def set_zoom ...
      @picture.set_zoom(...)
    end
    
    def zoom
      @picture.zoom
    end

    # Check wheather [+x+, +y+] is inside.
    def include_point ...
      @picture.include_point(...)
    end

    feature :frame # Current animation frame ms.

    def set_frame frame
      return if @frame == frame
      update_frame frame * @total_frames
      @frame = frame
      true
    end
    
    def frame
      @frame
    end

    # Get duration.
    def duration
      @duration
    end

    feature :segment # Animated segment.

    def set_segment *segment
      Pastele.animation_set_segment @pointer, *segment
    end

    # Attach related Kredki::Picture to the Kredki::Scene.
    def attach scene, at = nil
      @picture.attach scene, at
      self
    end

    # Detach related Kredki::Picture from the Kredki::Scene.
    def detach
      @picture.detach
    end

    feature :scenic # Whether Animation is scenic. All lower level Scenes must be scenic for the Animation to be displayed.

    def set_scenic value = true
      return if (c = scenic) == (value = value == Not ? !c : value)
      update_scenic value
      true
    end
    
    def scenic
      @picture.scenic
    end

    # :section: LEVEL 2

    def initialize
      @pointer = Pastele.animation_new
      ObjectSpace.define_finalizer(self, Animation.finalizer(@pointer))

      @picture = Picture.new Pastele.animation_get_picture @pointer
      @total_frames = nil
      @duration = nil
    end

    def self.finalizer pointer
      proc{ Pastele.animation_delete pointer }
    end

    attr :pointer
    attr :picture

    def scene
      @picture.scene
    end
    
    def scene= scene
      @picture.scene = scene
    end

    def update_scenic scenic
      @picture.update_scenic scenic
    end
  
    def update_frame frame_index
      Pastele.animation_set_frame @pointer, frame_index
      @picture.update
    end
  end
end
