module Kredki
  # Picture that may change over time.
  class Animation

    # Set animation content.
    def set_content ...
      if @picture.set_content(...)
        @duration = (Pastele.animation_get_duration(@pointer) * 1000).to_i
        @frame_ms_to_index = Pastele.animation_get_total_frames(@pointer) / @duration
        @frame = 0
        true
      end
    end

    # See #set_content.
    def content= param
      send_bundle :set_content, param
    end

    # Get content.
    def content
      @content
    end

    # Set size in X axis.
    def set_size_x ...
      @picture.set_size_x(...)
    end

    # See: #set_size_x
    def size_= param
      @picture.size_x = param
    end

    # Get size in X axis.
    def size_x
      @picture.size_x
    end

    # Set size in Y axis.
    def set_size_y ...
      @picture.set_size_y(...)
    end

    # See: #set_size_y
    def size_y= param
      @picture.size_y = param
    end

    # Get size in Y axis.
    def size_y
      @picture.size_y
    end

    # Set size.
    def set_size ...
      @picture.set_size(...)
    end

    # See: #set_size
    def size= param
      @picture.size = param
    end

    # Get size.
    def size
      @picture.size
    end

    # Set turn value.
    def set_turn ...
      @picture.set_turn(...)
    end

    # See: #set_turn
    def turn= param
      @picture.turn = param
    end

    # Get turn value.
    def turn
      @picture.turn
    end

    # Set zoom in the X axis.
    def set_zoom_x ...
      @picture.set_zoom_x(...)
    end

    # See: #set_zoom_x
    def zoom_x= param
      @picture.zoom_x = param
    end

    # Get zoom in the X axis.
    def zoom_x
      @picture.zoom_x
    end

    # Set zoom in the Y axis.
    def set_zoom_y ...
      @picture.set_zoom_y(...)
    end

    # See: #set_zoom_y
    def zoom_y= param
      @picture.zoom_y = param
    end

    # Get zoom in the Y axis.
    def zoom_y
      @picture.zoom_y
    end

    # Set zoom.
    def set_zoom ...
      @picture.set_zoom(...)
    end

    # See: #set_zoom
    def zoom= param
      @picture.zoom = param
    end

    # Get zoom.
    def zoom
      @picture.zoom
    end

    # Check wheather [+x+, +y+] is inside.
    def include_point ...
      @picture.include_point(...)
    end

    # Set current animation frame ms.
    def set_frame frame = @frame
      return set_frame yield @frame if block_given?
      return if @frame == frame
      update_frame frame * @frame_ms_to_index
      @frame = frame
      true
    end

    # See #set_frame.
    def frame= param
      send_bundle :set_frame, param
    end

    # Get current animation frame ms.
    def frame
      @frame
    end

    # Get duration.
    def duration
      @duration
    end

    # Set animated segment.
    def set_segment *segment
      Pastele.animation_set_segment @pointer, *segment
    end

    # Attach related Kredki::Picture to the Kredki::Scene.
    def attach scene, scenic = true, at = nil
      @picture.attach scene, scenic, at
      self
    end

    # Detach related Kredki::Picture from the Kredki::Scene.
    def detach
      @picture.detach
    end

    # Set whether Animation is scenic.
    #
    # All lower level Scenes must be scenic for the Animation to be displayed.
    def set_scenic value = true
      return if (c = scenic) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      update_scenic value
      true
    end

    # See #set_scenic.
    def scenic= value
      set_scenic value
    end
    
    # Get whether Animation is scenic.
    def scenic
      get_scenic
    end

    # Set a feature recognized by its class.
    def << feature
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

    def step ms, loop = false, &block
      if loop
        if block
          value = block.call ms, @duration
          return true if !value
          set_frame value
        else
          set_frame ms % @duration
        end
      else
        if block
          value = block.call ms, @duration
          return true if !value || value < 0 || value > @duration
          set_frame value
        else
          return true if ms > @duration
          set_frame ms
        end
      end
      false
    end

    # :section: LEVEL 2

    def initialize
      @pointer = Pastele.animation_new
      ObjectSpace.define_finalizer(self, Animation.finalizer(@pointer))

      @picture = Picture.new Pastele.animation_get_picture @pointer
      @frame_ms_to_index = nil
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
  
    def get_scenic
      @picture.get_scenic
    end

    def update_frame frame_index
      Pastele.animation_set_frame @pointer, frame_index
      @picture.update
    end
  end
end
