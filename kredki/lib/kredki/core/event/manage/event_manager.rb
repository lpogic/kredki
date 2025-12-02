require_relative 'block_event_resolver'
require_relative 'method_event_resolver'
require_relative 'job_event_resolver'

module Kredki
  # Manage generic event resolving.
  class EventManager

    # :section: LEVEL 2

    def initialize
      @resolvers = []
    end

    attr :resolvers

    def resolve event
      @resolvers.reverse_each do |r|
        r.resolve event
      end
    end

    def attach! attached = nil, always: false, last: false, &block
      attached ||= block
      resolver = case attached
      when Proc
        BlockEventResolver.new attached, self, always
      when Method
        MethodEventResolver.new attached, self, always
      when Job
        JobEventResolver.new attached, self, always
      when BlockEventResolver, MethodEventResolver, JobEventResolver
        attached.attach! self, always
      else raise_is attached
      end
      if last
        @resolvers.prepend resolver
      else
        @resolvers.append resolver
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