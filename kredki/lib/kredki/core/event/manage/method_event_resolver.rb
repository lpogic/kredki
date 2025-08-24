module Kredki
  class MethodEventResolver
    model :method, :@manager, :always

    def resolve event = nil
      return if !@always && event&.resolved?
      if event&.trace?
        puts @method.source_location
      end
      @method.call event
    end

    def resolve! event = nil
      resolve event
      self
    end

    def detach!
      @manager&.detach! self
      @manager = nil
      @method = nil
    end

    def attach! manager, always = false
      self.class.new @method, manager, always
    end
  end
end