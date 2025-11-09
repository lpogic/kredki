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
      @event_manager = ActionEventManager.new
      @event_director = EventDirector.new
      @fill = rectangle! xy: 0
      @the = The.new self
    end

    attr :last_frame_ms

    def use! id
      plugin = Kredki.plugin id
      raise_ia id unless plugin
      alter &plugin
    end

    def window ...
      @scene&.alter(...)
    end

    def action
      self
    end

    attr :the

    param def color! ...
      @fill.fill_color!(...)
    end, def color
      @fill.fill_color
    end

    def_delegators :window,
      :w, :h, :wh, :window!

    #internal api

    attr :step_callback, :event_manager, :event_director

    def update_paint paint
      @scene&.update_paint paint
    end

    def sketch
      
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

    def put_job job
      @jobs << job unless @jobs.include? job
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
    end

    def ms
      Abi.sdl_get_ticks
    end

    def main
      self
    end
  end
end
