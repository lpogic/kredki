require_relative '../scene'
require_relative '../event/step_event'

module Kredki
  class Action < Scene
    
    def initialize **params, &block

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

    def clipboard
      Kredki.clipboard
    end

    def keyboard &block
      Action::Keyboard.new(self, Kredki.keyboard).tap{|k| k.instance_exec &block if block }
    end

    def mouse &block
      Action::Mouse.new(self, Kredki.mouse).tap{|m| m.instance_exec &block if block }
    end

    def joystick param = nil, &block
      joystick = case param
      when Joystick
        param
      when Kredki::Joystick
        Action::Joystick.new self, param
      else
        j = Kredki.joystick(param)
        raise "Joystick #{param} not found" if !j
        Action::Joystick.new self, j
      end
      joystick.instance_exec &block if block
      joystick
    end

    def push_animation animation
      @animations << animation
    end

    def remove_animation animation
      @animations.delete animation
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

    require_relative 'action_events'
    include ActionEvents

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
      sketch self
      @sketched = true
      self
    end

    def translate x, y
      [x, y]
    end

    private

    def step ms
      @last_frame_ms = ms
      @jobs.filter!(&:audit)
      @animations.each{ _1.step ms }
      event StepEvent.new
      # @on_step&.call ms
    end


  end
end

require_relative 'action_keyboard'
require_relative 'action_mouse'
require_relative 'action_joystick'
