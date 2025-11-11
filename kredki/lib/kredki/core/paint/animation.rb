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
        content! param
      else
        super
      end
    end

    attr :picture

    param def content! content = @content
      return content! yield @content if block_given?
      return if @content == content
      set_content content
      @content = content
      @picture.update
    end

    def scene
      @picture.scene
    end
    
    def scene= scene
      @picture.scene = scene
    end

    param_delegate :@picture,
      :w, :h, :wh, :rot, :mag, :magx, :magy

    def contain? ...
      @picture.contain?(...)
    end

    def frame! frame_index
      set_frame frame_index
      @picture.update
    end

    attr :total_frame

    def duration
      (get_duration * 1000).to_i
    end

    param def play! play = true, &block
      play = block if play == true && block
      return if @play == play
      action = scene.action
      action.put_job self unless @play
      action.remove_job self unless play
      @play = play
      true
    end

    def segment! *segment
      Abi.animation_set_segment @pointer, *segment
    end

    def on_end! &block
      @on_end << block
    end

    def reset!
      self.frame = 0
      @ms = nil
      play! false
    end

    def attach! scene, show = true, at = nil
      @picture.action&.remove_job self if @play
      @picture.attach! scene, show, at
      @picture.action&.put_job self if @play
      self
    end

    def detach!
      play! false
      @picture.detach!
    end

    flag def show! value = true
      return if (c = show) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_show value
      true
    end, def show
      get_show
    end

    def finish!
      play! false and @on_end.resolve Event.new
    end

    #internal api

    def initialize
      @pointer = Abi.animation_new
      ObjectSpace.define_finalizer(self, Animation.proc.finalize(@pointer))

      @picture = Picture.new Abi.animation_get_picture @pointer
      @play = false
      @ms = nil
      @total_frame = nil
      @on_end = EventManager.new
    end

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

    def set_content content
      Abi.picture_load @picture.pointer, content
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
