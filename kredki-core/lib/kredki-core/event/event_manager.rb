require_relative 'event_resolver'

module Kredki
  class EventManager
    model do
      @resolvers = []
    end

    def resolve event
      event.unbreak
      @resolvers.reverse_each do |r|
        r.resolve event
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
      resolver.attach! self
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