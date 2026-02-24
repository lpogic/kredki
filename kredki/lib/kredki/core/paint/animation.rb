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

    # Set width.
    def w! ...
      @picture.w!(...)
    end

    # See: #w!
    def w= param
      @picture.w = param
    end

    # Get width.
    def w
      @picture.w
    end

    # Set height.
    def h! ...
      @picture.h!(...)
    end

    # See: #h!
    def h= param
      @picture.h = param
    end

    # Get height.
    def h
      @picture.h
    end

    # Set width and height.
    def wh! ...
      @picture.wh!(...)
    end

    # See: #wh!
    def wh= param
      @picture.wh = param
    end

    # Get height.
    def wh
      @picture.wh
    end

    # Set rotation angle.
    def rot! ...
      @picture.rot!(...)
    end

    # See: #rot!
    def rot= param
      @picture.rot = param
    end

    # Get rotation angle.
    def rot
      @picture.rot
    end

    # Set magnification factor.
    def mag! ...
      @picture.mag!(...)
    end

    # See: #mag!
    def mag= param
      @picture.mag = param
    end

    # Get magnification factor.
    def mag
      @picture.mag
    end

    # Set magnification factor along the X axis.
    def mag_x! ...
      @picture.mag_x!(...)
    end

    # See: #mag_x!
    def mag_x= param
      @picture.mag_x = param
    end

    # Get magnification factor along the X axis.
    def mag_x
      @picture.mag_x
    end

    # Set magnification factor along the Y axis.
    def mag_y! ...
      @picture.mag_y!(...)
    end

    # See: #mag_y!
    def mag_y= param
      @picture.mag_y = param
    end

    # Get magnification factor along the Y axis.
    def mag_y
      @picture.mag_y
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
      in [w, h]
        wh! w, h
      in Numeric
        wh! feature
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
