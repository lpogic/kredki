require_relative 'basic'

module Kredki
  module UI
    module Layout
      class Way < Basic
        model :<, :@space

        def tune space: nil
          @space == space ? self : self.class.new(@x, @y, space)
        end

        def get_span pad, s, ps
          case s
          when Range
            b = case s.begin
            when Rational
              r = ps * s.begin.to_f
              s.begin.denominator == 1 ? r / 100 : r
            when Numeric
              s.begin < 0 ? ps + s.begin : s.begin
            when nil
              0
            else raise s.begin
            end
            e = case s.end
            when Rational
              r = ps * s.end.to_f
              w.end.denominator == 1 ? r / 100 : r
            when Numeric
              w.end < 0 ? ps + s.end : s.end
            when nil
              Float::INFINITY
            else raise s.end
            end
            [(e - b).abs, b, pad]
          else
            get_fallback_span pad, s, ps
          end
        end
      end#Way
    end#Layout
  end#UI
end#Kredki