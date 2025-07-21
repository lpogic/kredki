require_relative '../event/manage/event_director'
require_relative '../event/step_event'
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

      @step_callback = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_VOID, [Fiddle::TYPE_INT], &proc.step)

      @jobs = []
      @animations = []
      @on_step = nil
      @event_manager = ActionEventManager.new
      @event_director = EventDirector.new
      @fill = nil

      super
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

    param def color! *color
      if !@fill
        @fill = rectangle! x: 0, y: 0
        on_resize = proc{ @fill.wh = ~it }
        on_window_resize! &on_resize
      end
      @fill.fill_color = color.unpack_one
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
      @event_director.push event, self
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
