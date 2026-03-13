module Kredki
  # Picture that may change over time.
  class Animation

    def content! ...
      if @picture.content!(...)
        @duration = (Pastele.animation_get_duration(@pointer) * 1000).to_i
        @frame_ms_to_index = Pastele.animation_get_total_frames(@pointer) / @duration
        @frame = 0
        true
      end
    end

    # See #content!.
    def content= param
      send_bundle :content!, param
    end

    # Get content.
    def content
      @content
    end

    # Set size in X axis.
    def size_x! ...
      @picture.size_x!(...)
    end

    # See: #size_x!
    def size_= param
      @picture.size_x = param
    end

    # Get size in X axis.
    def size_x
      @picture.size_x
    end

    # Set size in Y axis.
    def size_y! ...
      @picture.size_y!(...)
    end

    # See: #size_y!
    def size_y= param
      @picture.size_y = param
    end

    # Get size in Y axis.
    def size_y
      @picture.size_y
    end

    # Set size.
    def size! ...
      @picture.size!(...)
    end

    # See: #wh!
    def size= param
      @picture.size = param
    end

    # Get size.
    def size
      @picture.size
    end

    # Set turn value.
    def turn! ...
      @picture.turn!(...)
    end

    # See: #turn!
    def turn= param
      @picture.turn = param
    end

    # Get turn value.
    def turn
      @picture.turn
    end

    # Set zoom.
    def zoom! ...
      @picture.zoom!(...)
    end

    # See: #zoom!
    def zoom= param
      @picture.zoom = param
    end

    # Get zoom.
    def zoom
      @picture.zoom
    end

    # Set zoom in the X axis.
    def zoom_x! ...
      @picture.zoom_x!(...)
    end

    # See: #zoom_x!
    def zoom_x= param
      @picture.zoom_x = param
    end

    # Get zoom in the X axis.
    def zoom_x
      @picture.zoom_x
    end

    # Set zoom in the Y axis.
    def zoom_y! ...
      @picture.zoom_y!(...)
    end

    # See: #zoom_y!
    def zoom_y= param
      @picture.zoom_y = param
    end

    # Get zoom in the Y axis.
    def zoom_y
      @picture.zoom_y
    end

    # Check wheather [+x+, +y+] is inside.
    def contain? ...
      @picture.contain?(...)
    end

    # Set current animation frame ms.
    def frame! frame = @frame
      return frame! yield @frame if block_given?
      return if @frame == frame
      set_frame frame * @frame_ms_to_index
      @frame = frame
      true
    end

    # See #frame!.
    def frame= param
      send_bundle :frame!, param
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
    def segment! *segment
      Pastele.animation_set_segment @pointer, *segment
    end

    # Attach animation and related Kredki::Picture to the Kredki::Scene.
    def attach scene, show = true, at = nil
      @picture.attach scene, show, at
      self
    end

    # Detach animation and related Kredki::Picture from the Kredki::Scene.
    def detach
      @picture.detach
    end

    # Set whether Animation is drawn on the scene.
    #
    # Containing Kredki::Scene and all lower level Scenes must be shown for the Paint to be displayed on the screen.
    def show! value = true
      return if (c = show) == (value = block_given? ? yield(c) : value == Not ? !c : value)
      set_show value
      true
    end

    # See #show!.
    def show= value
      show! value
    end
    
    # Get whether Animation is drawn on the screen.
    def show
      get_show
    end

    # See #show.
    def show?
      !!show
    end

    # Push the feature.
    def << feature
      case feature
      in [x, y]
        size! x, y
      in Numeric
        size! feature
      in String
        content! feature
      else
        super
      end
    end

    def step ms, loop = false, &block
      if loop
        if block
          value = block.call ms, @duration
          return true if !value
          frame! value
        else
          frame! ms % @duration
        end
      else
        if block
          value = block.call ms, @duration
          return true if !value || value < 0 || value > @duration
          frame! value
        else
          return true if ms > @duration
          frame! ms
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

    def set_show show
      @picture.set_show show
    end
  
    def get_show
      @picture.get_show
    end

    def set_frame frame_index
      Pastele.animation_set_frame @pointer, frame_index
      @picture.update
    end
  end
end
