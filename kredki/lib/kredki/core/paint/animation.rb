module Kredki
  # Represents an picture that may change over time.
  class Animation

    def content! ...
      if @picture.content!(...)
        @total_frame = Pastele.animation_get_total_frame @pointer
        true
      end
    end

    # # Set content.
    # def content! content = @content
    #   return content! yield @content if block_given?
    #   return if @content == content
    #   Pastele.picture_load @picture.pointer, content.to_s
    #   @total_frame = Pastele.animation_get_total_frame @pointer
    #   @content = content
    #   @picture.update
    # end

    # See #content!.
    def content= param
      send_ahp :content!, param
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

    # Set current animation frame.
    def frame! frame_index
      Pastele.animation_set_frame @pointer, frame_index
      @picture.update
    end

    # Get total animation frames.
    attr :total_frame

    # Get animation duration in milliseconds.
    def duration
      (Pastele.animation_get_duration(@pointer) * 1000).to_i
    end

    # Run animation in given play mode.
    def play! play = true, &block
      play = block if play == true && block
      return if @play == play
      window = scene.window
      window.put_job self unless @play
      window.remove_job self unless play
      @play = play
      true
    end

    # See: #play!
    def play= param
      send_ahp :play!, param
    end

    # Get running play mode.
    def play
      @play
    end

    # Set animated segment.
    def segment! *segment
      Pastele.animation_set_segment @pointer, *segment
    end

    # Add animation finished event resolver.
    def on_finish! always: false, do: nil, &block
      resolver =  block || binding.local_variable_get(:do)
      resolver ? @on_finish.attach!(resolver, always: always) : @on_finish
    end

    # See: #on_finish=.
    def on_finish= param
      on_finish! do: param
    end

    # Stop and restore initial state of the Animation.
    def reset!
      self.frame = 0
      @ms = nil
      play! false
    end

    # Attach animation and related Kredki::Picture to the Kredki::Scene.
    def attach! scene, show = true, at = nil
      @picture.window&.remove_job self if @play
      @picture.attach! scene, show, at
      @picture.window&.put_job self if @play
      self
    end

    # Detach animation and related Kredki::Picture from the Kredki::Scene.
    def detach!
      play! false
      @picture.detach!
    end

    # Set whether Animation is drawn on the scene.
    #
    # Containing Kredki::Scene and all lower level Scenes must be shown for the Paint to be displayed on the screen.
    def show! value = true
      return if (c = show) == (value = block_given? ? yield(c) : value == :not ? !c : value)
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

    # Stop animation and report finish event.
    def finish!
      play! false and @on_finish.resolve Event.new
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

    # :section: LEVEL 2

    def initialize
      @pointer = Pastele.animation_new
      ObjectSpace.define_finalizer(self, Animation.finalizer(@pointer))

      @picture = Picture.new Pastele.animation_get_picture @pointer
      @play = false
      @ms = nil
      @total_frame = nil
      @on_end = EventManager.new
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

    def step ms
      @ms = ms if !@ms
      ms -= @ms
      d = duration
      case @play
      when :once, true
        if ms > d
          final_step
        else
          frame! ms * @total_frame / d
        end
      when :back
        if ms > d
          final_step
        else
          frame! (d - ms) * @total_frame / d
        end
      when :bounce
        d2 = d * 2
        if ms < d
          frame! ms * @total_frame / d
        elsif ms < d2
          frame! (d2 - ms) * @total_frame / d
        else
          final_step
        end
      when :loop
        frame! (ms % d) * @total_frame / d
        true
      when :back_loop
        frame! (d - (ms % d)) * @total_frame / d
        true
      when :bounce_loop
        d2 = d * 2
        rem = ms % d2
        if rem < d
          frame! rem * @total_frame / d
        else
          frame! (d2 - rem) * @total_frame / d
        end
        true
      when Proc
        if frame = @play.call(ms, duration)
          frame! frame * @total_frame / d
        else
          final_step
        end
      end
    end

    def final_step
      if @play
        @play = false
        @on_end.resolve Event.new
      end
      false
    end

    def set_show show
      @picture.set_show show
    end
  
    def get_show
      @picture.get_show
    end
  end
end
