module Kredki
  class Animation
    extend HasParams

    def << param
      case param
      in [w, h]
        wh! w, h
      in Numeric
        wh! param
      in String
        source! param
      else
        super
      end
    end

    def initialize
      @pointer = Abi.animation_new
      ObjectSpace.define_finalizer(self, Animation.proc.finalize(@pointer))

      @picture = Picture.new Abi.animation_get_picture @pointer
      @play = false
      @ms = nil
      @total_frame = nil
      @on_end = EventManager.new
    end

    attr :picture

    param def source! source
      return if @source == source
      set_source source
      @source = source
      @picture.update
    end

    def scene
      @picture.scene
    end
    
    def scene= scene
      @picture.scene = scene
    end

    param_delegate :@picture,
      :w, :h, :wh, :spin, :scale

    param def frame! frame_index
      set_frame frame_index
      @picture.update
    end, false

    attr :total_frame

    def duration
      (get_duration * 1000).to_i
    end

    param def play! play = true, &block
      play = block if play == true && block
      return if @play == play
      action = scene.action
      action.push_animation self unless @play
      action.remove_animation self unless play
      @play = play
      true
    end

    param def segment! *segment
      Abi.animation_set_segment @pointer, *segment
    end, false

    def on_end! &block
      @on_end << block
    end

    def reset!
      self.frame = 0
      @ms = nil
      play! false
    end

    def attach! scene, show = true, at = nil
      @picture.action&.remove_animation self if @play
      @picture.attach! scene, show, at
      @picture.action&.push_animation self if @play
      self
    end

    def detach!
      play! false
      @picture.detach!
    end

    flag def show! s = true
      c, n = show? s
      return if c == n
      set_show n
      true
    end, def show
      get_show
    end

    def finish!
      if @play
        play! false
        @on_end.resolve Event.new
      end
    end

    #internal api

    def self.finalize pointer
      Abi.animation_delete pointer
    end

    attr :pointer

    def step ms
      @ms = ms if !@ms
      ms -= @ms
      d = duration
      case @play
      when :once, true
        if ms > d
          finish!
          detach!
        else
          frame! ms * @total_frame / d
        end
      when :back
        if ms > d
          finish!
          detach!
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
          finish!
          detach!
        end
      when :loop
        frame! (ms % d) * @total_frame / d
      when :back_loop
        frame! (d - (ms % d)) * @total_frame / d
      when :bounce_loop
        d2 = d * 2
        rem = ms % d2
        if rem < d
          frame! rem * @total_frame / d
        else
          frame! (d2 - rem) * @total_frame / d
        end
      when Proc
        if frame = @play.call ms
          frame! frame * @total_frame / d
        else
          finish!
          detach!
        end
      end
    end

    def set_source source
      Abi.picture_load @picture.pointer, source
      @total_frame = Abi.animation_get_total_frame @pointer
    end

    def set_frame frame
      Abi.animation_set_frame @pointer, frame
    end

    def set_show show
      @picture.set_show show
    end
  
    def get_show
      @picture.get_show
    end

    def get_duration
      Abi.animation_get_duration @pointer
    end
  end
end
