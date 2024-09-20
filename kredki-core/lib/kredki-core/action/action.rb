require_relative '../scene'
require_relative '../event/step_event'
require_relative 'action_events'
require_relative '../context/context'
require 'forwardable'

module Kredki
  class Action < Scene
    include ActionEvents
    include Context
    extend Forwardable
    
    def initialize

      @step_callback = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_VOID, [Fiddle::TYPE_INT], &proc.step)

      @jobs = []
      @animations = []
      @on_step = nil
      @on_event = {}

      super
    end

    attr :last_frame_ms

    def use! extension, *a, **na, &b
      extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
    end

    def window ...
      @owner&.alter(...)
    end

    def action
      self
    end

    def color! *color
      fill = shape! x: 0, y: 0, color: color.extract;
      on_resize = proc do
        fill.alter do
          reset!
          rectangle_at! 0, 0, *window.size, 0, 0
        end
      end
      on_resize! &on_resize
      on_resize.call
      fill
    end

    def color=(color)
      color! *color
    end

    def job! repeat: false, run: true, &b
      job = Job.new repeat:, run:, &b
      @jobs << job
      job
    end
  
    def after! delay = nil, run: true, &b
      if delay
        job! run: do |j|
          sleep(delay / 1000.0)
          j.tips << nil
        end.on_tip &b
      else
        job!(run: false).on_tip(&b).tap{ _1.tips << nil }
      end
    end

    def_delegators :window,
      :wh, :size, :w, :width, :h, :height

    #internal api

    attr :step_callback

    def update_paint paint
      @owner&.update_paint paint
    end

    def on_event
      @on_event
    end

    def event_accumulator
      @owner&.event_accumulator
    end

    def sketch p0
    end

    def sketch_base
      sketch self if !sketched?
      @sketched = true
      self
    end

    def sketched?
      @sketched
    end

    def translate x, y
      [x, y]
    end

    def push_animation animation
      @animations << animation
    end

    def remove_animation animation
      @animations.delete animation
    end

    private

    def step ms
      @last_frame_ms = ms
      @jobs.filter!(&:audit)
      @animations.each{ _1.step ms }
      event StepEvent.new
    end

  end
end
