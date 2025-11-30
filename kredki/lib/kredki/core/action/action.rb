require_relative '../event/manage/event_director'
require_relative 'the'
require_relative 'action_events'
require_relative 'action_event_manager'
require_relative '../media/local_media'

module Kredki
  class Action < Scene
    extend HasFeatures
    include ActionEvents
    include LocalMedia
    
    def use! id, *a, **na
      plugin = Kredki.plugin id
      raise_ia id unless plugin
      instance_exec *a, **na, &plugin
    end

    def window ...
      @scene&.alter(...)
    end

    def action
      self
    end

    attr :the

    feature_delegate :@fill,
      :fill

    def_delegators :window,
      :w, :h, :wh, :window!

    # :section: LEVEL 2

    def initialize
      super

      @step_callback = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_VOID, [Fiddle::TYPE_INT], &proc.step)
      @jobs = []
      @event_manager = ActionEventManager.new
      @event_director = EventDirector.new
      @fill = rectangle! xy: 0
      @the = The.new self
    end

    attr :step_callback, :event_director

    def update_paint paint
      @scene&.update_paint paint
    end

    def sketch
      
      on_window_resize!{ @fill.wh = it.wh }
      @fill.wh = *wh
      fill! 20, 70, 20
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

    def put_job job
      @jobs << job unless @jobs.include? job
    end

    def remove_job job
      @jobs.delete job
    end

    def report event
      @event_director.push event, self
    end

    def resolve event, aim = false
      @event_manager.resolve event
    end

    def step ms
      @jobs.filter!{ it.step ms }
    end

    def altered
      self
    end
  end
end
