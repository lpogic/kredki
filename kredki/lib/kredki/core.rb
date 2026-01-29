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

      # def sin2pi value, offset = 0, scale = 1
      #   Math.sin(2 * Math::PI * value) + offset) * scale * 0.5 + 0.5
      # end

      def sin01 value, offset = 0
        Math.sin(0.5 * Math::PI * value) + offset
      end
  
      def cos01 value, offset = 0
        Math.cos(0.5 * Math::PI * value) + offset
        # Math.cos(Math::PI * 2 * value) * 0.5 + offset
      end
    end
  end
end

require_relative 'core/kredki'

load Kredki::Setup.config