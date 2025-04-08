require_relative 'event_resolver'

module Kredki
  class EventManager
    model do
      @resolvers = []
    end
    attr :resolvers

    def resolve event
      event.unbreak
      @resolvers.reverse_each do |r|
        r.resolve event
        break if event.break?
      end
    end

    def attach! attached, always: false, last: false
      resolver = case attached
      when EventResolver
        attached.attach! self, always;
      when Proc
        EventResolver.new attached, self, always
      else raise "Unsupported attached type (#{attached.class})"
      end
      if last
        @resolvers.prepend resolver
      else
        @resolvers << resolver
      end
      resolver
    end

    def <<(attached)
      attach! attached
      self
    end

    def detach! resolver
      @resolvers.delete resolver
    end
  end
end