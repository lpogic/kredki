module Kredki
  module Pads
    class NegativeTrace < Trace

      def initialize negated
        @negated = negated
      end

      attr :negated

      def enlist enum
        enum.yield self
        @negated.enlist enum
      end

    end
  end#Pads
end#Kredki