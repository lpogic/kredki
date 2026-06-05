module Kredki
  module Pads
    class Trace
      include Enumerable

      class << self
        def [](*a, **ka, &block)
          if block
            return Trace.new [*a, block] if ka.empty?
            return Trace.new [*a, ka, block]
          end
          return Trace.new a if ka.empty?
          Trace.new [*a, ka]
        end

        def + right
          case right
          when NegativeTrace then right.trace
          when Trace then right
          when Array then Trace[*right]
          else Trace[right]
          end
        end

        def - right
          case right
          when NegativeTrace then right
          when Trace then NegativeTrace.new right
          when Array then NegativeTrace.new Trace[*right]
          else NegativeTrace.new Trace[right]
          end
        end
      end

      def initialize data
        @data = data
      end

      attr :data

      def each
        Enumerator.new{|enum| enlist enum }
      end

      def enlist enum
        enum.yield self
      end

      def + right
        case right
        when NegativeTrace then CoupleTrace.new self, right.trace
        when Trace then CoupleTrace.new self, right
        when Array then CoupleTrace.new self, Trace[*right]
        else CoupleTrace.new self, Trace[right]
        end
      end

      def - right
        case right
        when NegativeTrace then CoupleTrace.new self, right
        when Trace then CoupleTrace.new self, NegativeTrace.new(right)
        when Array then CoupleTrace.new self, NegativeTrace.new(Trace[*right])
        else CoupleTrace.new self, NegativeTrace.new(Trace[right])
        end
      end

      def [](...)
        self + Trace.[](...)
      end

    end
  end#Pads
end#Kredki