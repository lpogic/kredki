require_relative '../event/manage/event_director'
require_relative '../event/step_event'
require_relative 'the'
require_relative 'action_events'
require_relative 'action_event_manager'
require_relative '../media/local_media'

module Kredki
  class Action < Scene
    include LocalMedia
    include ActionEvents
    extend Forwardable
    extend HasParams
    
    def initialize
      super

      @step_callback = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_VOID, [Fiddle::TYPE_INT], &proc.step)

      @jobs = []
      @animations = []
      @event_manager = ActionEventManager.new
      @event_director = EventDirector.new
      @fill = rectangle! xy: 0
      @the = The.new
    end

    attr :last_frame_ms

    def use! extension, *a, **na, &b
      extension.plug_into self, *a, **na, &b if extension.respond_to? :plug_into
    end

    def window ...
      @scene&.alter(...)
    end

    def action
      self
    end

    attr :the

    param def color! *color
      @fill.fill_color = color.pick
    end, def color
      @fill.fill_color
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
      :w, :h, :wh
      :window!

    #internal api

    attr :step_callback, :event_manager, :event_director

    def update_paint paint
      @scene&.update_paint paint
    end

    def sketch p0
      
      on_window_resize!{ @fill.wh = ~it }
      @fill.wh = *wh
      color! 20, 70, 20
    end

    def translate x, y, target = nil
      if target
        xy = target.translate -x, -y
        [-xy[0], -xy[1]]
      else
        [x, y]
      end
    end

    def screen_translate x, y, target = nil
      wx, wy = window.xy
      translate x - wx, y - wy, target
    end

    def push_animation animation
      @animations << animation
    end

    def remove_animation animation
      @animations.delete animation
    end

    def put_job job
      @jobs << job unless @jobs.include? job
    end

    def check_job_exclusion job
      !!@jobs.find{ check_ab_job_exclusion it, job }
    end

    def check_ab_job_exclusion a, b
      if a.exclusive == true || b.exclusive == true
        return true if a.pad == b.pad
      elsif a.exclusive == b.exclusive
        return true if a.pad == b.pad
      end
      return false
    end

    def remove_job job
      @jobs.delete job
    end

    def report event
      @event_director.push event, self
    end

    attr :event

    def resolve event, aim = false
      @event = event
      @event_manager.resolve event
    end

    def step ms
      @last_frame_ms = ms
      @jobs.filter!{ it.step ms }
      @animations.each{ it.step ms }
      # resolve StepEvent.new ms
    end

    def ms
      Abi.sdl_get_ticks
    end

    def build *a, **na, &block
      alter *a, **na, &block
    end
  end
end
