require 'kredki/setup'

module Kredki

  module Util
    class << self

      def eqr a, b
        a == b and (Rational === a) == (Rational === b)
      end

      def polarize left, right
        both = []
        right_only = right.reject{|it| both << it if left.include? it }
        [left - both, both, right_only]
      end

      def uncover array
        case array.size
        when 0 then nil
        when 1 then array.first
        else array
        end
      end

      def cover object
        object.is_a?(Array) ? object : [object]
      end

      def sin01 value, scale = 1
        (Math.sin(Math::PI * value / scale) * 0.5 + 0.5) * scale
      end
  
      def cos01 value, scale = 1
        (Math.cos(Math::PI * value / scale) * 0.5 + 0.5) * scale
      end
    end
  end
end

require_relative 'core/kredki'

load Kredki::Setup.config