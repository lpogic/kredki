module Kredki
  class Animation
    include Alterable
    extend HasFlags
    extend HasParams

    def initialize
      @pointer = Abi.animation_new
      ObjectSpace.define_finalizer(self, Animation.proc.finalize(@pointer))

      @picture = Paint.new Abi.animation_get_picture @pointer
      @base = nil
      @ms = nil
      @on_end = EventManager.new
    end

    attr :picture

    param def source! source
      return if @source == source
      set_source source
      @source = source
      @picture.update
    end

    param def frame! frame_index
      set_frame frame_index
      @picture.update
    end, false

    def total_frame
      Abi.animation_get_total_frame @pointer
    end

    def duration
      Abi.animation_get_duration @pointer
    end

    param def segment! *segment
      Abi.animation_set_segment @pointer, *segment
    end, false

    flag :loop
    flag :play, set: :set_play

    def on_end! &block
      @on_end << block
    end

    def reset!
      self.frame = 0
      @ms = nil
      play! false
    end

    def detach!
      play! false
      @picture.detach!
    end

    flag :show, set: :set_show, get: :get_show

    def finish!
      if @play
        play! false
        @on_end.resolve Event.new
      end
    end

    def window
      @base&.window
    end

    #internal api

    def self.finalize pointer
      Abi.animation_delete pointer
    end

    attr :pointer

    attr :base
    def base= base
      base, @base = @base, base
      if @play
        base&.remove_animation self
        @base&.push_animation self
      end
    end

    def step ms
      @ms = ms if !@ms
      d = (duration * 1000).to_i
      if @loop || ms <= @ms + d
        ms -= @ms
        self.frame = (ms % d) * total_frame / d
      else
        finish!
      end
    end

    private

    def set_source source
      Abi.picture_load @picture.pointer, source
    end

    def set_frame frame
      Abi.animation_set_frame @pointer, frame
    end

    def set_play play
      @play = play
      if @play
        @ms = @base.last_frame_ms - @ms if @ms
        @base&.push_animation self
      else
        @ms = @base.last_frame_ms - @ms if @ms
        @base&.remove_animation self
      end
    end

    def set_show show
      @picture.set_show show
    end
  
    def get_show
      @picture.get_show
    end
  end
end
