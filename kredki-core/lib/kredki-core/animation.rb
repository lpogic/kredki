require_relative 'flagship'

module Kredki
  class Animation
    include Alterable
    extend Flagship

    def initialize
      @pointer = Abi.animation_new
      ObjectSpace.define_finalizer(self, Animation.proc.finalize(@pointer))

      @picture = Paint.new Abi.animation_get_picture @pointer
      @owner = nil
      @ms = nil
      @on_end = EventManager.new
    end

    attr :picture

    aliasing def source! source
      set_source source
    end, :source=

    def source
      @source
    end

    aliasing def frame! no
      set_frame no
    end, :frame=

    def total_frame
      Abi.animation_get_total_frame @pointer
    end

    def duration
      Abi.animation_get_duration @pointer
    end

    def segment! *segment
      Abi.animation_set_segment @pointer, *segment
    end

    def segment= segment
      Abi.animation_set_segment @pointer, *segment
    end

    def_flag :loop
    def_flag :play

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

    def_flag :show, set: :set_show, get: :get_show

    def finish!
      if @play
        play! false
        @on_end.resolve Event.new
      end
    end

    def window
      @owner&.window
    end

    #internal api

    def self.finalize pointer
      Abi.animation_delete pointer
    end

    attr :pointer

    attr :owner
    def owner= owner
      owner, @owner = @owner, owner
      if @play
        owner&.remove_animation self
        @owner&.push_animation self
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
      if source != @source
        @source = source
        if @source
          Abi.picture_load @picture.pointer, @source
          @picture.update
        end
      end
    end

    def set_frame no
      Abi.animation_set_frame @pointer, no
      @picture.update
    end

    def set_play play
      @play = play
      if @play
        @ms = @owner.last_frame_ms - @ms if @ms
        @owner&.push_animation self
      else
        @ms = @owner.last_frame_ms - @ms if @ms
        @owner&.remove_animation self
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
