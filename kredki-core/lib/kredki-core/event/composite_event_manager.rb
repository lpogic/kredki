module Kredki
  class CompositeEventManager
    model :@managers

    def attach! attached
      resolver = case attached
      when EventResolver
        resolver
      when Proc
        EventResolver.new attached
      else raise "Unsupported attached type (#{attached.class})"
      end
      @managers.each{ _1.attach! resolver }
      resolver.manager = self
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