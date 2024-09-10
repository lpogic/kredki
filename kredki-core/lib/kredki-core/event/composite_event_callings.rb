module Kredki
  class CompositeEventCallings
    model :@callings

    def attach! attached
      calling = case attached
      when EventCalling
        calling
      when Proc
        EventCalling.new attached
      else raise "Unsupported attached type (#{attached.class})"
      end
      @callings.each{ _1.attach! calling }
      calling.director = self
      calling
    end

    def <<(attached)
      attach! attached
      self
    end

    def detach! calling
      @callings.each{ _1.detach! calling }
    end
  end
end