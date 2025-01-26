module Kredki
  class Job

    def initialize repeat:, run: true, &b
      @tips = Thread::Queue.new
      @mutex = Thread::Mutex.new
      @repeat = repeat
      @job = b
      @on_tip = EventManager.new
      self.run if run
    end

    def run
      if !@thread || !@thread.alive?
        @thread = Thread.new do
          loop do
            last_spin = false
            @mutex.synchronize do
              last_spin = !@repeat
            end
            @job.call self
            break if last_spin
          end
        end
      end
    end

    def on_tip &b
      @on_tip << b
      self
    end

    attr_accessor :tips
    attr :repeat

    def << value
      @tips << value
      self
    end

    aliasing def repeat! repeat
      @mutex.synchronize do
        @repeat = repeat
      end
    end, :repeat=

    def cancel!
      @thread&.kill
      @thread = @job = nil
    end

    #internal api

    def audit
      while !@tips.empty?
        tip = @tips.pop
        @on_tip.resolve Event.new
      end
      @thread ? @thread.alive? : !!@job
    end
  end
end