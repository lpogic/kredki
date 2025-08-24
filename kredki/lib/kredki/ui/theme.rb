module Kredki
  module UI
    class Theme

      def initialize
        @pad = nil
        @event_resolvers = nil
      end

      def attach! pad, event_managers = [], initial_event = nil
        return if @pad == pad
        detach! if @pad
        @pad = pad
        resolve = method :resolve
        @event_resolvers = event_managers.map{ it.attach! resolve, always: true, last: true }
        resolve initial_event if initial_event != false
      end

      def detach!
        @event_resolvers&.each{ it.detach! }
        @event_resolvers = @pad = nil
      end

      def resolve event
        repaint
      end

      def repaint
      end

    end
  end
end