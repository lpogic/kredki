require_relative 'event_calling'

module Kredki
  class EventCallings
    model do
      @callings = []
    end

    def call event
      @callings.sum{ _1.call event }
    end

    def attach! attached
      calling = case attached
      when EventCalling
        attached
      when Proc
        EventCalling.new attached
      else raise "Unsupported attached type (#{attached.class})"
      end
      calling.director = self
      @callings << calling
      calling
    end

    def <<(attached)
      attach! attached
      self
    end

    def detach! calling
      @callings.delete calling
    end
  end
end