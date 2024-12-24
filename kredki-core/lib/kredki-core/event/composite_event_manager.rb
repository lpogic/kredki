module Kredki
  class CompositeEventManager
    model :@managers

    def attach! attached, force = false
      resolver = case attached
      when EventResolver
        resolver.copy manager: self, force:;
      when Proc
        EventResolver.new attached, self, force
      else raise "Unsupported attached type (#{attached.class})"
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