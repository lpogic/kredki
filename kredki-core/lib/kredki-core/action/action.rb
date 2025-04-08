require_relative '../scene'
require_relative '../event/step_event'
require_relative 'action_events'
require_relative 'action_event_manager'
require_relative '../context/context'
require 'forwardable'

module Kredki
  class Action < Scene
    include Context
    include ActionEvents
    extend Forwardable
    
    def initialize

      @step_callback = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_VOID, [Fiddle::TYPE_INT], &proc.step)

      @jobs = []
      @animations = []
      @on_step = nil
      @event_manager = ActionEventManager.new

      super
    end

    attr :last_frame_ms

    def use! extension, *a, **na, &b
      extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
    end

    def window ...
      @base&.alter!(...)
    end

    def action
      self
    end

    param def color! *color
      fill = shape! x: 0, y: 0, color: (color.size > 1 ? color : color.first)
      on_resize = proc do
        fill.draw! do
          rectangle! 0, 0, *fill.window.size, 0, 0
        end
      end
      on_resize! &on_resize
      on_resize.call
      fill
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
      :wh, :size, :w, :width, :h, :height, 
      :window!

    #internal api

    attr :step_callback, :event_manager

    def update_paint paint
      @base&.update_paint paint
    end

    def sketch p0
      color! 0, 0, 0
    end

    def translate x, y, target = nil
      if target
        xy = target.translate -x, -y
        [-xy[0], -xy[1]]
      else
        [x, y]
      end
    end

    def push_animation animation
      @animations << animation
    end

    def remove_animation animation
      @animations.delete animation
    end

    def report event
      Kredki.event_director.push event, self
    end

    def resolve event, aim = false
      @event_manager.resolve event
    end

    def step ms
      @last_frame_ms = ms
      @jobs.filter!(&:audit)
      @animations.each{ _1.step ms }
      resolve StepEvent.new ms
    end

    def build *a, **na, &block
      alter *a, **na, &block
    end
  end
end
