module Kredki
  # Picture that may change over time.
  class Animation

    def content! ...
      if @picture.content!(...)
        @total_frames = Pastele.animation_get_total_frames @pointer
        true
      end
    end

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
    def total_frames
      @total_frames
    end

    # Get animation duration in milliseconds.
    def duration
      (Pastele.animation_get_duration(@pointer) * 1000).to_i
    end

    # Run animation in given play mode.
    def run! play_mode = true, &block
      play_mode = block if block
      return if @play_mode == play_mode
      window = scene.window
      window.remove_job self if @play_mode
      window.put_job self if play_mode
      @play_mode = play_mode
      true
    end

    # See: #run!
    def run= param
      send_ahp :run!, param
    end

    # Get running play mode.
    def run
      @play_mode
    end

    # See #run.
    def run?
      !!run
    end

    # Set animated segment.
    def segment! *segment
      Pastele.animation_set_segment @pointer, *segment
    end

    # Add animation finished event reaction.
    def on_finish always: false, do: nil, &block
      reaction =  block || binding.local_variable_get(:do)
      reaction ? @on_finish.attach(reaction, always: always) : @on_finish
    end

    # See: #on_finish=.
    def on_finish= param
      on_finish do: param
    end

    # Stop animation and report finish event.
    def finish
      run! false and @on_finish.report Event.new
    end

    # Stop and restore initial state of the Animation.
    def reset
      frame! 0
      @ms = nil
      run! false
    end

    # Attach animation and related Kredki::Picture to the Kredki::Scene.
    def attach scene, show = true, at = nil
      @picture.window&.remove_job self if @play_mode
      @picture.attach scene, show, at
      @picture.window&.put_job self if @play_mode
      self
    end

    # Detach animation and related Kredki::Picture from the Kredki::Scene.
    def detach
      run! false
      @picture.detach
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
      @play_mode = false
      @ms = nil
      @total_frames = nil
      @on_finish = EventManager.new
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

    def tick ms
      @ms = ms if !@ms
      ms -= @ms
      d = duration
      case @play_mode
      when :once, true
        if ms > d
          final_tick
        else
          frame! ms * @total_frames / d
        end
      when :back
        if ms > d
          final_tick
        else
          frame! (d - ms) * @total_frames / d
        end
      when :bounce
        d2 = d * 2
        if ms < d
          frame! ms * @total_frames / d
        elsif ms < d2
          frame! (d2 - ms) * @total_frames / d
        else
          final_tick
        end
      when :loop
        frame! (ms % d) * @total_frames / d
        true
      when :back_loop
        frame! (d - (ms % d)) * @total_frames / d
        true
      when :bounce_loop
        d2 = d * 2
        rem = ms % d2
        if rem < d
          frame! rem * @total_frames / d
        else
          frame! (d2 - rem) * @total_frames / d
        end
        true
      when Proc
        if frame = @play_mode.call(ms, duration)
          frame! frame * @total_frames / d
        else
          final_tick
        end
      end
    end

    def final_tick
      if @play_mode
        @play_mode = false
        @on_finish.report Event.new
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
