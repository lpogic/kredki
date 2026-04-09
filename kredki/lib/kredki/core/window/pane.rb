require_relative 'pane_event_manager'
require_relative 'pane_events'

module Kredki
  # Root element of Paint tree.
  class Pane < Scene
    include PaneEvents

    # Get window.
    def window
      @scene
    end

    # Set window.
    def window= window
      @scene = window
    end

    # Get application.
    def app
      window&.app
    end

    # Set background fill.
    def set_fill ...
      @fill.set_fill(...)
    end

    # See #set_fill.
    def fill= param
      send_bundle :set_fill, param
    end

    # Get background fill.
    def fill
      @fill.fill
    end

    # Create new job.
    def job run = true, &block
      job = AfterJob.new block, 0
      job.run self if run
      job
    end

    def exit_on_esc
      on_key_press.attach at: :last do |event|
        app.return if event.key.id == :escape
      end
    end

    def close_on_esc
      on_key_press.attach at: :last do |event|
        window.close if event.key.id == :escape
      end
    end

    # Set a feature recognized by its class.
    def << feature
      case feature
      when Hash
        set **feature
      when Array
        set *feature
      when Proc
        set &feature
      when Class, String, Pane
        window.pane = feature
      else
        raise "Unsupported << (#{feature} : #{feature.class})"
      end
      self
    end

    # :section: LEVEL 2

    def initialize
      super

      @last_xy = nil

      @jobs = {}
      @jobs_mutex = Thread::Mutex.new
      @event_manager = PaneEventManager.new
      @fill = new_rectangle xy: 0
      @sketched = false
    end

    def update_paint paint
      window&.update_paint paint
    end

    def sketch_pane
      return if @sketched
      @sketched = true
      sketch
      presence
      behavior
    end

    def sketch
      @fill.size = *window.size
      @last_xy = xy
      set_fill 20, 70, 20
    end

    def behavior
      on_resize do: method(:resize_event)
      on_move do: method(:move_event)
      on_expose do: method(:expose_event)
      on_tick do: method(:tick)
      on_close{ @jobs.each_key{|it| it.cancel } }
    end

    def presence
    end

    def service
      sketch_pane
      self
    end

    def arrange
    end

    def resize_event event
      @fill.size = event.param
    end

    def move_event event
      @last_xy = event.xy
    end

    def expose_event event
      w = window
      size = w.size
      w.report ResizeEvent.new(size[0], size[1], event) if size != @fill.size
      xy = w.xy
      w.report MoveEvent.new(*xy, event) if xy != @last_xy
      w.report TickEvent.new event
    end

    def translate x, y, target = nil
      if target
        xy = target.translate -x, -y
        [-xy[0], -xy[1]]
      else
        [x, y]
      end
    end

    def put_job job
      @jobs_mutex.synchronize do
        @jobs[job] = 1
      end
    end

    def remove_job job
      @jobs_mutex.synchronize do
        @jobs.delete job
      end
    end

    def jobs
      @jobs.each
    end

    def report event, early = false
      @event_manager.report event
    end

    def tick event
      ms = event.timestamp * 0.000001 - app.run_ms
      jobs = {**@jobs}
      jobs.each_key{|it| remove_job it unless it.tick ms }
    end
  end
end
