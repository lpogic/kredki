module Kredki
  # Collection of event managers used as a single entity.
  class CompositeEventManager

    # :section: LEVEL 2

    def initialize managers
      @managers = managers
    end

    def attach! attached, always: false
      resolver = case attached
      when BlockEventResolver
        BlockEventResolver.new attached.block, self, always
      when MethodEventResolver
        MethodEventResolver.new attached.method, self, always
      when JobEventResolver
        JobEventResolver.new attached.job, self, always
      when Proc
        BlockEventResolver.new attached, self, always
      else raise_ia attached
      end
      @managers.each{ _1.resolvers << resolver }
      resolver
    end

    def <<(attached)
      attach! attached
      self
    end

    def detach! resolver
      @managers.each{ _1.detach! resolver }
    end
  end
end