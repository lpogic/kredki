module Kredki
  module UI
    class Theme

      def initialize
        @pad = nil
        @event_resolvers = nil
      end

      def attach! pad, *event_managers
        return if @pad == pad
        detach! if @pad
        @pad = pad
        repaint = proc.repaint
        @event_resolvers = event_managers.map{ it.attach! repaint, always: true, last: true }
        repaint.call
      end

      def detach!
        @event_resolvers&.each{ it.detach! }
        @event_resolvers = @pad = nil
      end

      def repaint
      end

    end
  end
end