require_relative 'event_resolver'

module Kredki
  class EventManager
    model do
      @resolvers = []
    end

    def resolve event
      event.break false
      @resolvers.reverse_each do |r|
        event.forward false
        r.resolve event
        event.resolve if !event.forward?
        break if event.break?
      end
    end

    def attach! attached
      resolver = case attached
      when EventResolver
        attached
      when Proc
        EventResolver.new attached
      else raise "Unsupported attached type (#{attached.class})"
      end
      resolver.manager = self
      @resolvers << resolver
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