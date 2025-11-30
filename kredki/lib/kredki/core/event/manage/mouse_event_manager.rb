module Kredki
  class MouseEventManager
    model do
      @resolvers = {}
    end

    def resolve event
      @resolvers[event.input_id]&.resolve event
      @resolvers[nil]&.resolve event
    end

    def [](*indexes)
      case indexes.size
      when 0
        @resolvers[nil] ||= EventManager.new
      when 1
        @resolvers[indexes.first] ||= EventManager.new
      else
        CompositeEventManager.new indexes.map{ @resolvers[_1] ||= EventManager.new }
      end
    end
  end
end